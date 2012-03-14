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
        maxZoomScale: 2.0
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

      
      // _.each(response.teams, function(team) {
      //   Game.db.teams[team.id] = team;
      //   Ti.API.info('TEAM: ' + team.id);
      // });
      
      Ti.API.info(response.areas);
      
      _.each(response.areas, function(area) {
        Game.db.areas[area.id] = area;
        var areaView = Ti.UI.createView({
          top: area.y,
          left: area.x,
          backgroundColor: 'red',
          opacity: 0.8,
          width: area.width,
          height: area.height,
          
          // Custom properties
          selected: false
        });
        
        // var nameLabel = Ti.UI.createLabel({
        //   text: area.name
        // });
        Ti.API.info(areaView);
        // areaView.add(nameLabel);
        areaView.addEventListener('click', function(evt) {
          this.selected = !this.selected;
          this.opacity = 1 - this.opacity;
        });
        imgView.add(areaView);
      });
    }
		
		return win;
	};
})();

Ti.include("/struct/helpers/annotationHelpers.js");
//Ti.include("/struct/ui/clickview.js");