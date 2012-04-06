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
      return :result => 'error', :info => 'Insufficient minions'
    end

    @area = Area.find(area_id)
    if @user && @area && @area.owner == @user.team
      @user.update_attribute('minion_pool', @user.minion_pool - count)
      # TODO(george): This could fail if there is a bug in the client
      # where the place_minions command is issued with the wrong user_id
      @minion_group = @user.minion_groups.find_by_area_id(area_id)
      @minion_group.update_attribute('count', @minion_group.count + count)
      return :result => 'success', :area_id => @area.id, :minion_groups => @area.minion_groups
    else
      return :result => 'error', :info => 'You can only place minions on an area your team owns'
    end
  end


  def move_minions(from_area_id, to_area_id, count, user_id)
    @user = User.find(user_id)
    @from_area = Area.find(from_area_id)
    @to_area = Area.find(to_area_id)
    if @to_area.owner != @user.team
      return :result => 'error', :info => 'Your team needs to own the destination area'
    end
        
    @minions = @from_area.minion_groups.find_by_user_id(user_id)

    if count >= @minions.count
      return :result => 'error', :info => 'You need to leave at least ont minion behind'
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
      return :result => 'success', :minion_groups => @user.minion_groups, :areas => @user.areas
    else
      return :result => 'error', :info => 'I\'m not sure what happened'
    end
  end
  
  # Check to see if the areas are adjacent
  # Check if the areas are valid  
  def valid_attack(from_area_id, to_area_id, user_id)
    Rails.logger.info('User ' + user_id + ' attacking from area ' + from_area_id + ' to area ' + to_area_id)
    @user = User.find(user_id)

    # TODO(george): This check needs to be done more thoroughly, somewhere else
    @minion_group_on_area = @user.minion_groups.find_by_area_id(from_area_id)
    if @minion_group_on_area  && @minion_group_on_area == 0
      Rails.logger.info(@minion_group_on_area);
      return false, 'there is an empty minion_group'
      # Maybe we should also add the passive groups on the attacked area
    end
    
    @from_area = Area.find(from_area_id)    
    @to_area = Area.find(to_area_id)

    # If from area is owned by my team and I have minions on it
    # If to area is not owned by my team
    @from_area_valid = @from_area && 
                       @user.minion_groups.find_by_area_id(from_area_id)

    if not @from_area_valid
      return false, 'You need to attack from an area that you have minions on'
    end
    
    @to_area_valid = @to_area && @to_area.owner != @user.team
    if not @to_area_valid
      return false, 'You can only attack an area that does not belong to your team'
    end
    return true
  end

  # Attack an area using minions from any one neighboring areas
  # Attack all of the defending minion groups
  # Remove any minion groups that have been completely decimated
  def attack(from_area_id, to_area_id, user_id, attack_delay)
    valid_attack, errorMessage = valid_attack (from_area_id, to_area_id, user_id)
    if not valid_attack
      return 'error', errorMessage
    end

    attack_delay = 5 # testing
    @minion_group_on_area = User.find(user_id).minion_groups.find_by_area_id(from_area_id)
    # attack_delay should be guaranteed by the client to be in seconds
    # TODO(george): Ensure delay is never greater than some value?
    if attack_delay == 0
      execute_attack(from_area_id, to_area_id, user_id, attack_delay, @minion_group_on_area.id)
    else
      Delayed::Job.enqueue( AttackJob.new(from_area_id, to_area_id, user_id, attack_delay, @minion_group_on_area.id),
                          :priority => 0,  :run_at => attack_delay.seconds.from_now)
    end
  end

  def execute_attack(from_area_id, to_area_id, user_id, attack_delay, minion_group_id)
    Rails.logger.info('Executing attack!')
    @from_area = Area.find(from_area_id)
    @to_area = Area.find(to_area_id)
    @user = User.find(user_id)

    @attacking_minions = @from_area.minion_groups.find_by_user_id(user_id)
    Rails.logger.info('User ' + user_id.to_s() + ' attacking from area ' + from_area_id.to_s() + ' to area ' + to_area_id.to_s() + ' with ' + @attacking_minions.count.to_s() + ' minions')
    # Find the minion groups of the team that owns the area, in the attacked area
    @defending_minions = @to_area.owner.minion_groups.where(:area_id => @to_area.id).all
    
    @defending_minions_count = 0
    @defending_minions.each { |minion_group| @defending_minions_count += minion_group.count }
    Rails.logger.info('Team ' + @to_area.owner.color.to_s() + ' defending area ' + to_area_id.to_s() + ' with ' + @defending_minions_count.to_s() + ' minions')
    Rails.logger.info('Team ' + @to_area.owner.color.to_s() + ' defended by minion groups:')
    Rails.logger.info(@defending_minions.to_s())
    
    # Model the attack probability as an x-shifted sigmoid function http://tinyurl.com/sigmoid-fun
    @ratio = @attacking_minions.count / @defending_minions_count
    
    @winning_probability = 1 / (1 + Math.exp(-4 * (@ratio - 1.02)))
    @win = Random.rand(1.0) < @winning_probability ? 1 : 0
    
    Rails.logger.info('Win: ' + @win.to_s())
    
    # Kill 20% of minions on each side
    Rails.logger.info(@defending_minions.to_s())    
    @defending_minions.each { |dm| dm.update_attribute('count', (dm.count * 0.8).floor) }
    Rails.logger.info('Team ' + @to_area.owner.color.to_s() + ' minion groups after attack:')
    Rails.logger.info(@defending_minions)    
    @defending_minions.each do |dm| 
      if dm.count == 0
        dm.destroy
      end
    end

    # TODO(george): We should ensure that some attacking minions always survive - some to stay behind, and some to take over the new area
    @attacking_minions.update_attribute('count', (@attacking_minions.count * 0.8).floor)
    Rails.logger.info('Player ' + user_id.to_s() + ' minion groups after attack:')
    Rails.logger.info(@attacking_minions.count.to_s())
    if @attacking_minions.count == 0
      @attacking_minions.destroy
    end
    
    @win = 1
    if @win == 1 
      @to_area.update_attribute('owner_id', @user.team_id)
    end
    Rails.logger.info('Attacked area now belongs to team: ' + @to_area.owner.color)
    
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
    Rails.logger.info '\nUser does not exist so we will create one\n'

    # User doesn't exist so we need to create one (via a team!)
    
    # We first find the team with the least members
    # The below is a HACK since I'm injecting SQL to optimize this query (limiting the results to one)
    @team_id_count_hash = User.count(:team_id, :group => 'team_id', :order => 'count_team_id ASC LIMIT 1')
    
    # Extract the key-pair as an array, and get the team_id from the resulting array
    @team_id = @team_id_count_hash.first[0]
    
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
