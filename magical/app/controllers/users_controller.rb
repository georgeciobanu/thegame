class UsersController < ApplicationController
  def create
    # Play is a generic function
    # If the user exists log them in
    # otherwise create the user and log them in
    # unless the data they provide is invalid and then return error
    Rails.logger.info 'email is: ' + params[:email]
    Rails.logger.info 'pass is: ' + params[:password]
    @respo = User.Play(params[:email], params[:password])
    Rails.logger.info 'Response is: '
    Rails.logger.info @respo
    render :json => @respo
  end
  
  def info
    # Get all the info needed for the user
    @user = User.find(params[:id])
    @team = Team.find(@user.team_id)
    @game_map = GameMap.find(@team.game_map_id)
    @areas = @game_map.areas
    
    render :json => { :user => @user, :team => @team, :game_map => @game_map, :areas => @areas }
  end
  
  def index
    render :json => User.all
  end
  
  def attack
  end
  
end
