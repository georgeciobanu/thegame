/**
* Appcelerator Titanium Platform
* Copyright (c) 2009-2011 by Appcelerator, Inc. All Rights Reserved.
* Licensed under the terms of the Apache Public License
* Please see the LICENSE included with this distribution for details.
**/
// Code is stripped-down version of Tweetanium, to expose new structure paradigm

(function() {
	var platformWidth = Ti.Platform.displayCaps.platformWidth;
	
	//create the main application window
	Game.ui.createMapWindow = function(_args) {
		var win = Ti.UI.createWindow(Game.combine(Game.ui.properties.Window,{
			orientationModes:[Ti.UI.PORTRAIT]
		}));
        
    var imgView = Ti.UI.createImageView({
        image:'/struct/images/cu_denver_campus.png'
    });
    
    var mapView = Ti.UI.createScrollView({
        maxZoomScale: 4.0
    });
    mapView.add(imgView);
    win.add(mapView);
    win.addEventListener('focus', getMapInfo);

    function getMapInfo(e) {
      // Get areas, teams and the number of minions the player owns on each of those (info?)
      Game.rest.callAPI('GET', '/users/' + Game.db.user.id + '/info', refreshMapView);
    }
    
    function refreshMapView(e) {
      response = JSON.parse(this.responseText);
      Game.db.user.team = response.team;
      Game.db.user.minion_groups = response.my_minion_groups;
      Game.db.game_map = response.game_map;
      Game.db.team_minion_groups = response.team_minion_groups;
      
      _.each(response.teams, function(team) {
        Game.db.teams[team.id] = team;
        Ti.API.info('TEAM: ' + team.id);
      });
      
      _.each(response.areas, function(area) {
        Game.db.areas[area.id] = area;
        var areaView = Ti.UI.createView({
          top: area.y,
          left: area.x,
          backgroundColor: Game.db.teams[area.owner_id].color,
          opacity: 0.8,
          width: area.width,
          height: area.height,
          layout: 'vertical',
          
          // Custom properties
          area_id: area.id
        });
                
        var nameLabel = Ti.UI.createLabel({
          text: area.name,
          font: {fontSize:8}
        });
        Ti.API.info(areaView);
        areaView.add(nameLabel);

        var ownerLabel = Ti.UI.createLabel({
          text: Game.db.teams[area.owner_id].name,
          font: {fontSize:8}
        });
        Ti.API.info(areaView);
        areaView.add(ownerLabel);

        areaView.addEventListener('click', function(evt) {
          
          
          // TODO(george): Move all the non-UI code in a helper file
          
          
          // Only interact with areas I have minions on
          Ti.API.info(evt.source);
          minion_group_on_area = null;
          minion_group_on_area = _.find(Game.db.user.minion_groups, 
                                        function (minion_group) {
                                          return minion_group.area_id === evt.source.area_id;
                                        });
          
          if (minion_group_on_area === null) {
            return;
          }
            
          switch (Game.ui.selected_id) {
            // This is the first click on an area -> select it
            case -1:
              Game.ui.selected_id = evt.source.area_id;
              this.opacity = 1 - this.opacity;
              break;
            
            // This is the second click on the same area  -> deselect it
            case evt.source.area_id:
              Game.ui.selected_id = -1;
              this.opacity = 1 - this.opacity;                          
              break;
              
            // This is the second click on a different area  -> move or attack
            default:
              // Second click was on our team's area -> it's a Move request
              // otherwise, if it's an opponent's area that's adjacent, it's an Attack request
              if (Game.db.areas[evt.source.area_id].owner_id == Game.db.user.team_id) {
                // Note: the Move API accepts a count - by default it moves all the minions (but one)
                Game.rest.callAPI('PUT', '/user/' + Game.db.user.id + '/move',
                                  parseMoveResponse, 
                                  {from_area_id: Game.ui.selected_id, to_area_id: evt.source.area_id});
                // This is a good time to update the whole thing
              } else { // Second click was on opponent's area -> it's an Attack request
                Game.rest.callAPI('PUT', '/user/' + Game.db.user.id + '/attack',
                                  parseAttackResponse,
                                  {from_area_id: Game.ui.selected_id, to_area_id: evt.source.area_id});
              }
              this.opacity = 1 - this.opacity;                        
          }
          

          if (Game.ui.selected_id == evt.source.area_id) {
            // Deselect the square
          } else 
          Game.ui.selected_id = this.area_id;

        });
        Game.db.areas[area.id].view = areaView;
        mapView.add(areaView);
      });

      Ti.API.info('minion count per area');
      _.each(response.area_owner_minion_count, function (owner_minion_count, area_id) {
        Ti.API.info('Area:' + area_id);
        Ti.API.info('Owner minion count:' + owner_minion_count);        
        Game.db.areas[area_id].owner_minion_count = owner_minion_count;
      });


      Ti.API.info(response.my_team_minion_count);
      _.each(response.my_team_minion_count, function (minion_count, area_id) {
        Ti.API.info('Area:' + area_id);
        Ti.API.info('My team minion count:' + minion_count);        
        Game.db.areas[area_id].my_team_minion_count = minion_count;
        var myTeamMinionCountLabel = Ti.UI.createLabel({
          text: 'Your team has: ' + minion_count + ' minions here',
          font: {fontSize:8}
        });
        Game.db.areas[area_id].view.add(myTeamMinionCountLabel);
      });
    }

		return win;
	};
})();

Ti.include("/struct/helpers/annotationHelpers.js");
//Ti.include("/struct/ui/clickview.js");