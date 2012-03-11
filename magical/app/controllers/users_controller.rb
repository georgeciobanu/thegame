class UsersController < ApplicationController
  def create
    # Play is a generic function
    # If the user exists log them in
    # otherwise create the user and log them in
    # unless the data they provide is invalid and then return error
    Rails.logger.info 'email is: ' + params[:email]
    Rails.logger.info 'pass is: ' + params[:password]
    respo = User.Play(params[:email], params[:password])
    Rails.logger.info 'Response is: '
    Rails.logger.info respo
    render :json => respo
  end
  
  def info
    # Get all the info needed for the user
    @user_info = User.info(params[:user_id])
    
  end
  
end
