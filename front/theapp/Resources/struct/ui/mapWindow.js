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
		var areas = [];
		
    // Game.rest.callAPI('GET', '/areas', processAreas);
		
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
          selected: false
        });
                
        var nameLabel = Ti.UI.createLabel({
          text: area.name,
          font: {fontSize:4}
          // height: 10,
          // width: 30
        });
        Ti.API.info(areaView);
        areaView.add(nameLabel);

        var ownerLabel = Ti.UI.createLabel({
          text: Game.db.teams[area.owner_id].name,
          font: {fontSize:4}
        });
        Ti.API.info(areaView);
        areaView.add(ownerLabel);
        // if ()
        // var myMinionsLabel = Ti.UI.createLabel({
        //   text: Game.db.teams[area.owner_id].name,
        //   font: {fontSize:4}
        // });
        // Ti.API.info(areaView);
        // areaView.add(ownerLabel);

        areaView.addEventListener('click', function(evt) {
          this.selected = !this.selected;
          this.opacity = 1 - this.opacity;
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
          font: {fontSize:4}
        });
        Game.db.areas[area_id].view.add(myTeamMinionCountLabel);
      });
    }
		
		return win;
	};
})();

Ti.include("/struct/helpers/annotationHelpers.js");
//Ti.include("/struct/ui/clickview.js");