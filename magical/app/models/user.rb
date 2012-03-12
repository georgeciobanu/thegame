# == Schema Information
#
# Table name: users
#
#  id              :integer(4)      not null, primary key
#  name            :string(255)
#  email           :string(255)
#  team_id         :integer(4)
#  minion_pool     :integer(4)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation, :team_id, :minion_pool
  has_secure_password
  
  belongs_to :team
  has_many :minion_groups
  has_many :areas, :through => :minion_groups

#  validates :name, presence: true, length: { maximum: 50 }
  valid_email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i  
  validates :email, presence: true, 
                    format: {with: valid_email_regex},
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }


  def place_minions(area_id, count, user_id)
    @user = User.find(user_id)
    if @user.minion_pool < count
      return 'error', 'Insufficient minions'
    end
    
    @area = Area.find(area_id)
    if @user && @area && @area.owner == @user.team
      @user.update_attribute('minion_pool', @user.minion_pool - count)
      # TODO(george): This could fail if there is a bug in the client
      # where the place_minions command is issued with the wrong user_id
      @minion_group = @user.minion_groups.find_by_area_id(area_id)
      @minion_group.update_attribute('count', @minion_group.count + count)
      return 'success', :area_id => @area.id, :minion_groups => @area.minion_groups
    else
      return 'error', 'You can only place minions on an area your team owns'
    end
  end
  

  def move_minions(from_area_id, to_area_id, count, user_id)
    @user = User.find(user_id)
    @from_area = Area.find(from_area_id)
    @to_area = Area.find(to_area_id)
    if @from_area.owner != @user.team || @to_area.owner != @user.team
      return 'error', 'Your team needs to own both areas'
    end
        
    @minions = @from_area.minion_groups.find_by_user_id(user_id)

    if count >= @minions.count
      return 'error', 'You need to leave at least ont minion behind'
    end

    if @user && @from_area && @to_area
      @minion_src = @user.minion_groups.find_by_area_id(from_area_id)
      @minion_dst = @user.minion_groups.find_by_area_id(to_area_id)
      
      # If the user does not have a group on the destination area (but someone else on their team does)
      if @minion_dst == nil
        @minion_dst = MinionGroup.create(area_id: to_area_id, count: count)
      else
        @minion_dst.update_attribute('count', @minion_dst.count + count)
      end
      
      @minion_src.update_attribute('count', @minion_src.count - count)
      return 'success', :minion_groups => @user.minion_groups, :areas => @user.areas
    else
      return 'error', 'I\'m not sure what happened'
    end
  end
  

  def attack(from_area_id, to_area_id, user_id)
    @user = User.find(user_id)

    # TODO(george): count checks
    @from_area = Area.find(from_area_id)    
    @to_area = Area.find(to_area_id)

    # If from area is owned by my team and I have minions on it
    # If to area is not owned by my team
    @from_area_valid = @from_area && 
                       # @from_area.owner == @user.team && 
                       @user.minion_groups.find_by_area_id(from_area_id)
    if not @from_area_valid 
      return 'error', 'You need to attack from an area that you own'
    end
    @to_area_valid = @to_area && @to_area.owner != @user.team
    if not @to_area_valid
      return 'error', "You need to attack an area that does not belong to your team"
    end
    
    # both areas are valid
    @from_area_valid && @to_area_valid
    @attacking_minions = @from_area.minion_groups.find_by_user_id(user_id)
    @defending_minions = @to_area.minion_groups.first
#      @diff = @attacking_minions.count - @defending_minions.count
    
    @win = Random.rand(1.0).round
    
    # Kill 20% of minions on each side
    # TODO(george): override update_attribute such that is count == 0 delete minion_group
    @defending_minions.update_attribute('count', (@defending_minions.count * 0.8).round)
    @attacking_minions.update_attribute('count', (@attacking_minions.count * 0.8).round)
    
    if @win == 1 
      @to_area.owner = @user.team
    end
    
    return :won => @win
  end


  def self.Play(email, password)
    @user = User.find_by_email(email)

    if @user
      Rails.logger.info '\nUser exists so we check the password\n'
      if @user.authenticate(password)
        return :result => 'login', :user => @user
      else
        Rails.logger.info '\nPassword is invalid'
        return :result => 'invalid password', :user => nil
      end
    end
    Rails.logger.info '\nUser does not exists so we will create one\n'

    # User doesn't exist so we need to create one (via a team!)
    
    # We first find the team with the least members
    # The below is a HACK since I'm injecting SQL to optimize this query (limiting the results to one)
    @teamid_count_hash = User.count(:team_id, :group => 'team_id', :order => 'count_team_id ASC LIMIT 1')
    
    # Extract the key-pair as an array, and get the team_id from the resulting array
    @team_id = @teamid_count_hash.first[0]
    
    #And then we finally get the team
    @team = Team.find(@team_id)
    
    @user = @team.members.new(email: email, password: password)
  
    if @user.save
      Rails.logger.info '\nUser created, will return\n'
      return :result => 'new', :user => @user
    else 
      return :result => 'error', :details => @user.errors.full_messages
    end
  end
  
  def get_info(user_id)
    @user = User.find(user_id)
    @team = Team.find(@user.team_id)
    
  end
    
    
end
