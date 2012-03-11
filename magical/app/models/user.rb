# == Schema Information
#
# Table name: users
#
#  id              :integer(4)      not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string(255)
#  team_id         :integer(4)
#

class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation, :team_id
  has_secure_password
  
  belongs_to :team

#  validates :name, presence: true, length: { maximum: 50 }
  valid_email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :email, presence: true, 
                    format: {with: valid_email_regex},
                    uniqueness: { case_sensitive: false }

  validates :password, length: { minimum: 6 }


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
