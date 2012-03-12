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
		
		Game.rest.callAPI('GET', '/areas', processAreas);
		
		var win = Ti.UI.createWindow(Game.combine(Game.ui.properties.Window,{
			orientationModes:[Ti.UI.PORTRAIT]
		}));
		
		var mapView = Ti.Map.createView({
			mapType: Titanium.Map.STANDARD_TYPE,
			region: {latitude:33.74511, longitude:-84.38993, 
					latitudeDelta:0.01, longitudeDelta:0.01},
			animate:true,
			regionFit:true,
			userLocation:true,
		});

		// This should amuse Liviu
		var clickView = Ti.UI.createView({
		  top: 0,
		  left:0,
      // backgroundColor: 'red',
      // opacity: 0,
		  zIndex: 1000
		});
		
		clickView.addEventListener('click', function(e){
		  Ti.API.info('Hidden click');
		  Alert('You just clicked on the map. Bitches!');
		});
		
		win.add(clickView);
		
		function processAreas(e){
			var color = "red";
			
			var returnedAreas = JSON.parse(this.responseText);
			_.each(returnedAreas, function(area) {
				addAnnotation(area, color);
				if(color == "red"){
					color = "blue";
				}
				else{
					color = "red";
				}
			});
			
			mapView.addAnnotations(areas);
		}
		
		function addAnnotation(area, color){
			var newArea = Ti.Map.createAnnotation({
				title: area.name + " Area",
				latitude: area.lat,
				longitude: area.long,
				color: color,//area.color,
				minions: 100,//area.minions,
				subtitle: "Minions " + 100,//area.minions,
				animate: false,
				image: imagesLocation + color + "_" + area.name.charAt(0).toLowerCase() + area.name.slice(1) + "." + imagesType,//area.color,
				myid: area.name
			});
			
			areas.push(newArea);
		}
		
		win.add(mapView);
		//win.add(imageView);
		// Handle click events on any annotations on this map.
		mapView.addEventListener('click', function(evt) {
			if(evt.clicksource == "pin"){
				setArea(evt.annotation);
				//createView(evt.annotation);
			}
		});
		
		return win;
	};
})();

Ti.include("/struct/helpers/annotationHelpers.js");
//Ti.include("/struct/ui/clickview.js");