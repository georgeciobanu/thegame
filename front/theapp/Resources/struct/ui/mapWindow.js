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
		

		return win;
	};
})();