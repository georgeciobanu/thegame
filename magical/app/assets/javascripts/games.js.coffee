jQuery ->
  infoUrl = '/users/1/info'
  
  info = {}
  my_minion_groups = {}
  areas = {}
  teams = {}
  current_user = {}
  area_owner_minion_count = {}
  
  previous_area_id = -1

  # set click behavior of navbar links
  $("#urlMap a").click ->
    setActiveNavbarItem(this)
    renderMap infoUrl
  $("#urlInfo a").click -> 
    setActiveNavbarItem(this)
    renderInfo()

  renderInfo = () ->
    $("#GameView").empty()
    $("#GameView").html("<br/><br/><p>This is where I will insert info</p>")

  processInfoResponse = (data, textStatus, jqXHR) ->
    console.log(data)
    info = data
    area_owner_minion_count = data.area_owner_minion_count
    
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
    addAreaListeners(area) for key, area of areas

    $("#minionPool a").html(current_user.minion_pool)
    $("#teamName a").html('Team: ' + teams[current_user.team_id].color)
    $("#userName a").html(current_user.name)

    console.dir(current_user)



    # Need to factor out into a template file, this was prototype code
    # Need to decide what information to put here, should probably include game links
    # and various other types of links

  renderArea = (area) ->
    console.log('area_' + area.id.toString())
    # TODO(george): This needs to be factored out in a template file
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
    
  
  addAreaListeners = (area) ->
    $("#area_#{ area.id}").click ->
      # console.log $(@).data('area_id')      
      area_id = $(@).data('area_id')
      console.log 'clicked: ' + area_id

      switch previous_area_id
      # This is the first click on an area -> select it
        when -1
          # (name for name in list when name.length < 5)
          minion_group_on_area = my_minion_groups[area_id]
          if minion_group_on_area?
            console.log('-1 : you have MG here') 
            console.log(minion_group_on_area)
          else 
            console.log('-1 : no MG here')
          previous_area_id = area_id
        when area_id
          # This is the second click on the same area  -> deselect it
          console.log 'Second click on the same area, deselecting'
          previous_area_id = -1
        else
          # TODO(george): check that the areas are adjacent      
          console.log 'Second click on different area (not same as first click)'
          # Second click was on our team's area -> it's a Move request
          console.log 'Owner of area you just clicked on: ' + areas[area_id].owner_id
          console.log 'Your team id: ' + current_user.team_id
          
          if areas[area_id].owner_id == current_user.team_id
            # Note: the Move API accepts a count - by default it moves all the minions (but one)
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