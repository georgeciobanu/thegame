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
		
		var artsAnnotation = Ti.Map.createAnnotation({
			latitude:33.74511,
			longitude:-84.38993,
			title:"Arts Area",
			subtitle:'Blue Team',
			animate:true,
			image: '/struct/images/blueArts.png',
			myid: 'arts'// Custom property to uniquely identify this annotation.
		});
		
		var engineeringAnnotation = Ti.Map.createAnnotation({
			latitude:33.75511,
			longitude:-84.38993,
			title:"Engineering Area",
			subtitle:'Red Team',
			animate:true,
			image: '/struct/images/redEngineering.png',
			myid: 'engineering' // Custom property to uniquely identify this annotation.
		});
		
		var scienceAnnotation = Ti.Map.createAnnotation({
			latitude:33.74511,
			longitude:-84.43993,
			title:"Science Area",
			subtitle:'Blue Team',
			animate:true,
			image: '/struct/images/blueEngineering.png',
			myid: 'science' // Custom property to uniquely identify this annotation.
		});
		
		var sportsAnnotation = Ti.Map.createAnnotation({
			latitude:33.75511,
			longitude:-84.43993,
			title:"Sports Area",
			subtitle:'Red Team',
			animate:true,
			image: '/struct/images/redSports.png',
			myid: 'sports' // Custom property to uniquely identify this annotation.
		});
		 
		var mapView = Ti.Map.createView({
			mapType: Titanium.Map.STANDARD_TYPE,
			region: {latitude:33.74511, longitude:-84.38993, 
					latitudeDelta:0.01, longitudeDelta:0.01},
			animate:true,
			regionFit:true,
			userLocation:true,
			annotations:[artsAnnotation, engineeringAnnotation, scienceAnnotation, sportsAnnotation]
		});
		
		win.add(mapView);
		//win.add(imageView);
		// Handle click events on any annotations on this map.
		mapView.addEventListener('click', function(evt) {
		 	Ti.API.info('clicked ' + evt.clicksource);
		 	if(evt.clicksource == "pin"){
				swapSubtitle(evt.annotation, evt.annotation.subtitle.split(" ")[0]);
			}
		});
		
		return win;
	};
})();

Ti.include("/struct/helpers/annotationHelpers.js");