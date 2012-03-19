(function() {

  Game.helpers.areaViewClickHandler = function(evt) {
    
    // TODO(george): Move all the non-UI code in a helper file
    // Only interact with areas I have minions on
    Ti.API.info('Click handler. Area id: ' + evt.source.area_id);

    switch (Game.ui.selected_id) {
      // This is the first click on an area -> select it
      case -1:
        minion_group_on_area = null;
        minion_group_on_area = _.find(Game.db.user.minion_groups, 
                                      function (minion_group) {
                                        return minion_group.area_id === evt.source.area_id;
                                      });
        Ti.API.info(minion_group_on_area);

        if (minion_group_on_area == null) {
          Ti.API.info('Clicked an area where you don\'t have minions, exiting');
          Ti.API.info('Selected should be -1: ' + Game.ui.selected_id);          
          return;
        }
     
        Ti.API.info('First click on area where you have minions');        
        Game.ui.selected_id = evt.source.area_id;
        this.opacity = 1 - this.opacity;
        break;
    
      // This is the second click on the same area  -> deselect it
      case evt.source.area_id:
        Ti.API.info('Second click on same area, deselecting');      
        Game.ui.selected_id = -1;
        this.opacity = 1 - this.opacity;                  
        break;

      // This is the second click on a different area  -> move or attack
      default:
        // TODO(george): check that the areas are adjacent      
        Ti.API.info('Second click on different area (not same as first click)');
        // Second click was on our team's area -> it's a Move request
        Ti.API.info('Owner of area you just clicked on: ' + Game.db.areas[evt.source.area_id].owner_id);
        Ti.API.info('Your team id: ' + Game.db.user.team_id);
        if (Game.db.areas[evt.source.area_id].owner_id == Game.db.user.team_id) {
          // Note: the Move API accepts a count - by default it moves all the minions (but one)
          Game.rest.callAPI('PUT', '/users/' + Game.db.user.id + '/move_minions',
                            parseMoveResponse, 
                            {from_area_id: Game.ui.selected_id, to_area_id: evt.source.area_id});
          // This is a good time to update the whole thing

        // Second click was on opponent's area -> it's an Attack request
        } else { 
          Game.rest.callAPI('PUT', '/users/' + Game.db.user.id + '/attack',
                            parseAttackResponse,
                            {from_area_id: Game.ui.selected_id, to_area_id: evt.source.area_id});
          this.opacity = 1 - this.opacity;
          Game.db.areas[Game.ui.selected_id].view.opacity = 1 - Game.db.areas[Game.ui.selected_id].view.opacity;
        }
        
        Game.ui.selected_id = -1;
    }
  }


  function parseAttackResponse() {
    response = JSON.parse(this.responseText);
    if (response.result == 'error') {
      setTimeout(function(){Ti.App.fireEvent("app:msg",{msg:"Whoops: " + response.info });},1000);
    } else {
      setTimeout(function(){Ti.App.fireEvent("app:msg",{msg:"Area attacked."});},1000);
      // TODO(george): refresh stuff
    }      
  }

  function parseMoveResponse() {
    response = JSON.parse(this.responseText);
    if (response.result == 'error') {
      setTimeout(function(){Ti.App.fireEvent("app:msg",{msg:"Whoops: " + response.info });},1000);
    } else {
      setTimeout(function(){Ti.App.fireEvent("app:msg",{msg:"Minions moved."});},1000);
      // TODO(george): refresh stuff
    }
  }

})();

