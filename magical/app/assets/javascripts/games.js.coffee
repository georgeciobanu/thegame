jQuery ->
  url = '/users/1/info'
  
  info = {}
  my_minion_groups = {}
  areas = {}
  teams = {}
  current_user = {}
  
  previous_area_id = -1

  processInfoResponse = (data, textStatus, jqXHR) ->
    console.log(data)
    info = data
    my_minion_groups = data.my_minion_groups
    
    # Helper function
    add_to_hash = (hash, key, val) ->
      hash[key] = val
    
    add_to_hash(areas, area.id, area) for area in data.areas
    add_to_hash(teams, team.id, team) for team in data.teams
    add_to_hash(my_minion_groups, mg.id, mg) for mg in data.my_minion_groups
    current_user = info.user

    renderArea(area) for key, area of areas
    addAreaListeners(area) for key, area of areas

  renderArea = (area) ->
    console.log('area_' + area.id.toString())
    $('#GameMap').append("
      <div id=\'area_#{ area.id }\'
      style=\"position: absolute; top: #{area.y}px; left: #{area.x}px; 
      width: #{area.width}px; height: #{area.height}px; background-color: #{ teams[area.owner_id].color };\"
      onmouseover=\"this.style.backgroundColor=\'red\'\" onmouseout=\"this.style.backgroundColor=\'blue\'\" 
      onclick=\"this.style.backgroundColor=\'green\'\">
      <p> Area #{ area.id }</p>
      </div>")
    $("#area_#{ area.id }").data('area_id', area.id)
    
  
  addAreaListeners = (area) ->
    $("#area_#{ area.id}").click ->
      # console.log $(@).data('area_id')      
      area_id = $(@).data('area_id')
      console.log 'clicked: ' + area_id

      switch previous_area_id
      # This is the first click on an area -> select it
        when -1
          # (name for name in list when name.length < 5)
          minion_group_on_area = (mg for key, mg of my_minion_groups when mg.area_id == area_id)[0]
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
            $.ajax '/users/' + current_user.id + '/move_minions',
              type: 'PUT'
              dataType: 'json'
              data: {from_area_id: previous_area_id, to_area_id: area_id}
              error: (jqXHR, textStatus, errorThrown) ->
                console.log('Move failed because: ' + textStatus + errorThrown)
              success: (jqXHR, textStatus, errorThrown) ->
                console.log('Moved successfully!')
          else
            console.log('We shall attack!')
            # This is a good time to update the whole thing
                
            # Second click was on opponent's area -> it's an Attack request
            $.ajax '/users/' + current_user.id + '/attack',
              type: 'PUT'
              dataType: 'json'
              data:  {from_area_id: previous_area_id, to_area_id: area_id}
              error: (jqXHR, textStatus, errorThrown) ->
                console.log('Attack failed because: ' + textStatus + errorThrown)
              success: (jqXHR, textStatus, errorThrown) ->
                console.log('Attacked successfully!')
            previous_area_id = -1
      
      
    # $("#area_#{ area.id}").hover(
    #   ->$(this).fadeIn(150),
    #   ->$(this).fadeOut(150))
  
  $.ajax url,
    type: 'GET' 
    dataType: 'json' 
    error: (jqXHR, textStatus, errorThrown) ->
      console.log(errorThrown)
    success: processInfoResponse
  
    
  iVolunteerAsYourAutomaticReturn = true