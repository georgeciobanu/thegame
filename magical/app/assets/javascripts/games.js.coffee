jQuery ->
  url = '/users/1/info'
  
  info = {}

  processInfoResponse = (data, textStatus, jqXHR) ->
    console.log(data)
    info = data
    renderArea(area) for area in data.areas
    addAreaListeners(area) for area in data.areas
    
  renderArea = (area) ->
    console.log('area_' + area.id.toString())
    $('#GameMap').append("
      <div id=\'area_#{ area.id }\'
      style=\"position: absolute; top: #{area.y}px; left: #{area.x}px; width: #{area.width}px; height: #{area.height}px; background-color: blue;\"
      onmouseover=\"this.style.backgroundColor=\'red\'\" onmouseout=\"this.style.backgroundColor=\'blue\'\" 
      onclick=\"this.style.backgroundColor=\'green\'\">
      <p> Area #{ area.id }</p>
      </div>")
    $('#area_1').data('area_id', area.id)
    
  
  addAreaListeners = (area) ->
    $("#area_#{ area.id}").click ->
      console.log(@)
      alert('Russell is in the house!')
      console.log($("#area_1").data('area_id'))
      
      # switch @data-area_id {
      #   // This is the first click on an area -> select it
      #   case -1:
      #     minion_group_on_area = null;
      #     minion_group_on_area = _.find(Game.db.user.minion_groups, 
      #                                   function (minion_group) {
      #                                     return minion_group.area_id === evt.source.area_id;
      #                                   });
      #     Ti.API.info(minion_group_on_area);
      # 
      #     if (minion_group_on_area == null) {
      #       Ti.API.info('Clicked an area where you don\'t have minions, exiting');
      #       Ti.API.info('Selected should be -1: ' + Game.ui.selected_id);          
      #       return;
      #     }
      # 
      #     Ti.API.info('First click on area where you have minions');        
      #     Game.ui.selected_id = evt.source.area_id;
      #     this.opacity = 1 - this.opacity;
      #     break;
      # 
      #   // This is the second click on the same area  -> deselect it
      #   case evt.source.area_id:
      #     Ti.API.info('Second click on same area, deselecting');      
      #     Game.ui.selected_id = -1;
      #     this.opacity = 1 - this.opacity;                  
      #     break;
      # 
      #   // This is the second click on a different area  -> move or attack
      #   default:
      #     // TODO(george): check that the areas are adjacent      
      #     Ti.API.info('Second click on different area (not same as first click)');
      #     // Second click was on our team's area -> it's a Move request
      # 
      #     Ti.API.info('Owner of area you just clicked on: ' + Game.db.areas[evt.source.area_id].owner_id);
      #     Ti.API.info('Your team id: ' + Game.db.user.team_id);
      #     if (Game.db.areas[evt.source.area_id].owner_id == Game.db.user.team_id) {
      #       // Note: the Move API accepts a count - by default it moves all the minions (but one)
      #       Game.rest.callAPI('PUT', '/users/' + Game.db.user.id + '/move_minions',
      #                         parseMoveResponse, 
      #                         {from_area_id: Game.ui.selected_id, to_area_id: evt.source.area_id});
      #       // This is a good time to update the whole thing
      # 
      #     // Second click was on opponent's area -> it's an Attack request
      #     } else { 
      #       Game.rest.callAPI('PUT', '/users/' + Game.db.user.id + '/attack',
      #                         parseAttackResponse,
      #                         {from_area_id: Game.ui.selected_id, to_area_id: evt.source.area_id});
      #       this.opacity = 1 - this.opacity;
      #       Game.db.areas[Game.ui.selected_id].view.opacity = 1 - Game.db.areas[Game.ui.selected_id].view.opacity;
      #     }
      # 
      #     Game.ui.selected_id = -1;
      # }
      # 
      
      
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