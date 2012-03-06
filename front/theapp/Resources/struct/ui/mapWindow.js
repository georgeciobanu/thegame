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
	
	mapView = Ti.UI.createView({
    backgroundColor: "red"
	});
	win.add(mapView);

  // Create the regions
  var width = 100, height = 100;
  for (i = 0; i < 6; i++) {
    var tView = Ti.UI.createView({
      top: Math.floor(i / 2) * height + Math.floor(i/2) * 10 + 30,
      left: (i % 2) * width + 30 + (i % 2) * 10,
      width: width,
      height: height,
      backgroundColor: 'green'
    });
    Ti.API.info(tView.top);
    mapView.add(tView);
  }

	return win;
	};
})();