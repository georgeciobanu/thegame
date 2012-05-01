
jQuery ->
  infoUrl = '/users/1/info'
  
  info = {}
  my_minion_groups = {}
  areas = {}
  teams = {}
  current_user = {}
  area_owner_minion_count = {}
  attack_jobs_by_from_area = {}
  game_map ={}

  previous_area_id = -1

  # set click behavior of navbar links
  $("#urlMap a").click ->
    setActiveNavbarItem(this)
    renderMap infoUrl
  $("#urlInfo a").click -> 
    setActiveNavbarItem(this)
    renderInfo()
  $("#urlMinions a").click ->
    setActiveNavbarItem(this)
    renderMinions()

  renderInfo = () ->
    $.get '../users/' + current_user.id + '/info', (data) -> 
      $("#GameView").html(data)

  renderMinions = () ->
    $("#GameView").html("<br/><br/><p>This is where you can get extra minions</p>")

  processInfoResponse = (data, textStatus, jqXHR) ->
    console.log "Data:"
    console.log(data)
    info = data
    area_owner_minion_count = data.area_owner_minion_count
    attack_jobs_by_from_area = data.attack_jobs_by_from_area
    game_map = data.game_map

    # Helper function
    add_to_hash = (hash, key, val) ->
      hash[key] = val
    
    add_to_hash(areas, area.id, area) for area in data.areas
    add_to_hash(teams, team.id, team) for team in data.teams
    add_to_hash(my_minion_groups, mg.area_id, mg) for mg in data.my_minion_groups
    current_user = info.user

    $("#GameView").empty()
    $("#GameView").html("<div id=\"Map\" style=\"position: relative;\"><img src=\"/assets/campus.png\" alt=\"Some text\"/></div>")
    renderArea(area) for key, area of areas
    renderScheduledAttack(area) for key, area of areas when attack_jobs_by_from_area[area.id]?
    addAreaListeners(area) for key, area of areas

    $("#minionPool a").html(current_user.minion_pool)
    $("#teamSpan").css("color",teams[current_user.team_id].color)
    $("#teamSpan").html(teams[current_user.team_id].name)
    $("#userName a").html(current_user.name)

    console.dir(current_user)



    # Need to factor out into a template file, this was prototype code
    # Need to decide what information to put here, should probably include game links
    # and various other types of links

  renderArea = (area) ->
    console.log('area_' + area.id.toString())
    # TODO(george): This needs to be factored out in a template file - backbone?
    $('#GameView').append("
      <div id=\'area_#{ area.id }\'
      style=\"position: absolute; top: #{area.y}px; left: #{area.x}px; 
      width: #{area.width}px; height: #{area.height}px; 
      -webkit-transform: rotate(60deg);
      background-color: #{ teams[area.owner_id].color };\"
      opacity: 0.8;
      onmouseover=\"this.style.backgroundColor=\'orange\'\" 
      onmouseout=\"this.style.backgroundColor=\'#{ teams[area.owner_id].color }\'\"
      onclick=\"this.style.backgroundColor=\'green\'\">
      <p style=\"font-size:90%;color:black\">
      <b> #{ area.name}</b> <br/>
      Team #{ teams[area.owner_id].name } <br/>
      #{ area_owner_minion_count[area.id] } minions <br/>
       #{ if my_minion_groups[area.id]? then 'you:' + my_minion_groups[area.id].count else '' }
      </p>
      </div>")
    $("#area_#{ area.id }").data('area_id', area.id)

  renderScheduledAttack = (area) ->
    aj = attack_jobs_by_from_area[area.id]
    dy = (areas[aj.to_area_id].y - area.y)
    dx = (areas[aj.to_area_id].x - area.x)
    if dx != 0
      slope = dy / dx
    else
      slope = 0
    console.log "Angle" + Math.atan(slope)
    # Draw an arrow
    $("#GameView").append("
    <div id=\"area_#{ area.id}_scheduled_attack\"
    style=\"position: absolute; top: #{area.y }px; left: #{area.x + area.width / 2 }px;
    width: 145px; height: 55px;
    background-color:yellow;
    opacity: 0.9;
    -webkit-transform: rotate(#{ Math.atan(slope) }rad);\">
    This is an arrow. Better believe it!      
    </div>")


  delay = 3 # 3 seconds - to be obtained from user via UI
  performAction = (action, from_area_id, area_id, delay) ->
    if action not in ['move_minions', 'attack_area', 'place_minions']
      return 'raise InvalidAction exception here'

    switch action
      when 'move_minions' then data = {from_area_id: from_area_id, to_area_id: area_id}
      when 'attack_area' then data = {from_area_id: from_area_id, to_area_id: area_id, delay: 3}
      else return 'raise NotImplemented exception here'
    
    # Note: the Move API accepts a count - by default it moves all the minions but one
    $.ajax '/users/' + current_user.id + '/' + action,
      type: 'PUT'
      dataType: 'json'
      data: data
      error: (jqXHR, textStatus, errorThrown) ->
        console.log(action + ' failed because: ' + textStatus + errorThrown)
      success: (jqXHR, textStatus, errorThrown) ->
        console.log('Successfully performed ' + action)
    
  drawActionArrow = (area, to_area) ->
    return if attack_jobs_by_from_area[area.id]?.to_area_id == to_area.id

    if to_area.owner_id != current_user.team_id
      dy = (to_area.y - area.y)
      dx = (to_area.x - area.x)
      if dx != 0
        slope = dy / dx
      else
        slope = 0
      $("#GameView").append("
      <div id=\"area_#{ area.id}_attack\"
      class=\"attackArrow\"
      style=\"position: absolute; top: #{area.y + area.height / 2}px; left: #{area.x }px;
      width: 145px; height: 55px;
      background-color:red;
      opacity: 0.9;
      -webkit-transform: rotate(#{ Math.atan(slope) }rad);\">
      Attack!      
      </div>")
      

  addAreaListeners = (area) ->
    $("#area_#{ area.id}").click ->
      # console.log $(@).data('area_id')      
      area_id = $(@).data('area_id')
      console.log 'clicked: ' + area_id

      switch previous_area_id
      # This is the first click on an area -> select it
        when -1
          if my_minion_groups[area_id]?
            console.log('you have MG here') 
          else 
            console.log('-1 : no MG here')
          previous_area_id = area_id
          
          # If this is an area my team owns and I have minions here
          if area.owner_id == current_user.team_id and my_minion_groups[area.id]?
            # Draw arrows to all surrounding areas that do not have an attack
            drawActionArrow(area, to_area) for key, to_area of areas when to_area.id in game_map.adjacency_list[area.id]

        when area_id
          # This is the second click on the same area  -> deselect it
          console.log 'Second click on the same area, deselecting'
          $(".attackArrow").remove()
          previous_area_id = -1
        else
          # TODO(george): check that the areas are adjacent      
          console.log 'Owner of area you just clicked on: ' + areas[area_id].owner_id
          console.log 'Your team id: ' + current_user.team_id
          
          if areas[area_id].owner_id == current_user.team_id
            # Note: the Move API accepts a count - by default it moves all the minions (but one)
            console.log 'Moving minions'
            performAction('move_minions', previous_area_id, area_id)
            previous_area_id = -1
          else
            console.log('We shall attack!')
            # Second click was on opponent's area -> it's an Attack request
            performAction('attack_area', previous_area_id, area_id, delay)
            previous_area_id = -1
            
          # TODO: trigger sever-side updates or periodic refreshing
          renderMap infoUrl

  renderMap = (url) ->
    $.ajax url,
      type: 'GET' 
      dataType: 'json' 
      error: (jqXHR, textStatus, errorThrown) ->
        console.log(errorThrown)
      success: processInfoResponse
  
  # removes active from previously active navbar item and sets navItem as active
  setActiveNavbarItem = (navbarItem) ->
    $("#navbar a.active").removeClass('active')
    $(navbarItem).addClass('active')


  renderMap infoUrl
  

    
  iVolunteerAsYourAutomaticReturn = true