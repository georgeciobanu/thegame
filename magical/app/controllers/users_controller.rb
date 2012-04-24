class UsersController < ApplicationController
  def create
    # If the user exists log them in
    # otherwise create the user and log them in
    # unless the data they provide is invalid and then return error
    @respo = User.Play(params[:email], params[:password])
    render :json => @respo
  end
  
  def info
    # Get all the info needed for the user
    @user = User.find(params[:id])
    @my_team = Team.find(@user.team_id)
    @game_map = GameMap.find(@my_team.game_map_id)
    @areas = @game_map.areas

    # Return all the attack jobs
    @attack_jobs_by_from_area = {}
    Delayed::Job.all.each do |dj|
      @aj = YAML::load dj.handler
      @attack_jobs_by_from_area[@aj.from_area_id] = @aj
    end
    

    # Return the minion count for each area, of the team that owns it
    @area_owner_minion_count = {}
    @my_team_minion_count = {}
    Area.all.each do |area|
      @sum = MinionGroup.sum(:count, :conditions => "area_id =" + area.id.to_s() + " AND user_id IN" + area.owner.member_ids.
          to_s().
          # Replace square brackets with parens
          sub('[', '(').
          sub(']', ')'))
      @area_owner_minion_count[area.id] = @sum

      # Return the minion count for my team, for all areas where we have minions
      @my_team_sum = MinionGroup.sum(:count, :conditions => "area_id =" + area.id.to_s() + " AND user_id IN" + @my_team.member_ids.
          to_s().
          # Replace square brackets with parens
          sub('[', '(').
          sub(']', ')'))
      if @my_team_sum > 0
        @my_team_minion_count[area.id] = @my_team_sum
        Rails.logger.info('Sum on area ' + area.id.to_s() + ' is: ' + @my_team_sum.to_s())        
      end
    end

    render :json => { :user => @user, :team => @my_team, :game_map => @game_map,
                      :areas => @areas, :my_minion_groups => @user.minion_groups,
                      :my_team_minion_count => @my_team_minion_count, :area_owner_minion_count => @area_owner_minion_count,
                      :teams => Team.all, :attack_jobs_by_from_area => @attack_jobs_by_from_area }
  end

  def index
    render :json => User.all
  end

  def attack_area
    @user = User.find params[:id]
    @result = @user.attack_area params[:from_area_id], params[:to_area_id], params[:id], params[:delay]
    Rails.logger.info("Result:")    
    Rails.logger.info(@result)

    render :json => @result
  end
  
  def join_attack
    @mg = MinionGroup.find params[:leading_minion_group_id]
    @user = User.find params[:id]
    
    @result = @user.join_attack @mg.id, params[:user_id]
    Rails.logger.info("Result:")    
    Rails.logger.info(@result)

    render :json => @result
  end

  def place_minions
    @user = User.find params[:id]
    @result = @user.place_minions params[:area_id], Integer(params[:count]), params[:id]
    Rails.logger.info("Result:")    
    Rails.logger.info(@result)
    render :json => @result
  end

  def move_minions
    @user = User.find params[:id]
    if not params[:count]
      params[:count] = @user.minion_groups.find_by_area_id(params[:from_area_id]).count - 1
    end

    @result = @user.move_minions params[:from_area_id], params[:to_area_id], Integer(params[:count]), params[:id]
    Rails.logger.info("Result:")    
    Rails.logger.info(@result)

    render :json => @result
  end
  

end
