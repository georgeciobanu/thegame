class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  has_secure_password

#  validates :name, presence: true, length: { maximum: 50 }
  valid_email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :email, presence: true, 
                    format: {with: valid_email_regex},
                    uniqueness: { case_sensitive: false }
                      
  validates :password, length: { minimum: 6 }


  def self.Play(email, password)
    @user = User.find_by_email(email)

    if @user 
      Rails.logger.info '\nUser exists so we will return is\n'      
      return @user
    end
    Rails.logger.info '\nUser does not exists so we will create one\n'
    
    # User doesn't exist so we need to create one
    @user = User.create(email: email, password: password)
  
    if @user
      Rails.logger.info '\nUser created, will return\n'
      return @user
    else 
      return @user.errors.full_messages
    end
  end
    
    
end
