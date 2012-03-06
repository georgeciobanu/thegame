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
      Rails.logger.info '\nUser exists so we check the password\n'
      if @user.authenticate(password)
        return :result => 'login', :user => @user
      else
        Rails.logger.info '\nPassword is invalid'
        return :result => 'invalid password', :user => nil
      end
    end
    Rails.logger.info '\nUser does not exists so we will create one\n'

    # User doesn't exist so we need to create one
    @user = User.new(email: email, password: password)
  
    if @user.save
      Rails.logger.info '\nUser created, will return\n'
      return :result => 'new', :user => @user
    else 
      return :result => 'error', :details => @user.errors.full_messages
    end
  end
    
    
end
