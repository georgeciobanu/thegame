/**
* Appcelerator Titanium Platform
* Copyright (c) 2009-2011 by Appcelerator, Inc. All Rights Reserved.
* Licensed under the terms of the Apache Public License
* Please see the LICENSE included with this distribution for details.
**/
// Code is stripped-down version of Tweetanium, to expose new structure paradigm
Ti.include("/struct/helpers/areaViewHelpers.js");

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


    Game.mapWindow.getMapInfo = function(e) {
      // Get areas, teams and the number of minions the player owns on each of those (info?)
      Game.rest.callAPI('GET', '/users/' + Game.db.user.id + '/info', refreshMapView);
    }
    
    win.addEventListener('focus', Game.mapWindow.getMapInfo);    

    function refreshMapView(e) {
      Ti.API.info('In refreshMapView');
      response = JSON.parse(this.responseText);

      // This needs to be extracted into updateLocalStore
      Game.db.user.team = response.team;
      Game.db.user.minion_groups = response.my_minion_groups;
      Game.db.game_map = response.game_map;
      Game.db.team_minion_groups = response.team_minion_groups;
      Game.db.teams = {};
      Game.db.areas = {};

      _.each(response.areas, function(area) {
        Ti.API.info('Printing them areas: ' + area.id);
        Game.db.areas[area.id] = area;
      });

      _.each(response.teams, function(team) {
        Game.db.teams[team.id] = team;
        Ti.API.info('TEAM: ' + team.id);
      });
      // to here

      _.each(response.areas, function(area) {
        // Cleanup
        Game.db.areas[area.id].view = null;        
        Game.db.areas[area.id] = null;
        
        Game.db.areas[area.id] = area;
      });

      Ti.API.info('minion count per area');
      _.each(response.area_owner_minion_count, function (owner_minion_count, area_id) {
        Ti.API.info('Area:' + area_id);
        Ti.API.info('Owner minion count:' + owner_minion_count);        
        Game.db.areas[area_id].owner_minion_count = owner_minion_count;
      });

      // TODO(george): Unclear if below is necessary
      _.each(mapView.getChildren, function(child) {
        mapView.remove(child);
        child.hide();
      });
      renderMapView(Game.db.areas, Game.db.teams, Game.helpers.areaViewClickHandler);
    }


    function renderMapView(areas, teams, areaViewClickHandler) {
      Ti.API.info('In render');
      Ti.API.info('I see: ' + areas);
      _.each(areas, function(area) {
        var areaView = Ti.UI.createView({top: area.y, left: area.x, 
            backgroundColor: teams[area.owner_id].color, opacity: 0.8,
            width: area.width, height: area.height, layout: 'vertical',
          // Custom properties
            area_id: area.id
        });

        // var nameLabel = Ti.UI.createLabel({
        //   text: area.name,
        //   font: {fontSize:4}
        // });
        // Ti.API.info(area);
        // areaView.add(nameLabel);
        // 
        // var ownerLabel = Ti.UI.createLabel({
        //   text: teams[area.owner_id].name,
        //   font: {fontSize:4}
        // });
        // Ti.API.info('MapView:');
        // Ti.API.info(mapView);
        // areaView.add(ownerLabel);

        areaView.addEventListener('click', areaViewClickHandler);
        areas[area.id].view = areaView;
        mapView.add(areaView);
      });
    }
  	return win;
	};    
	
})();

// Ti.include("/struct/helpers/annotationHelpers.js");
//Ti.include("/struct/ui/clickview.js");