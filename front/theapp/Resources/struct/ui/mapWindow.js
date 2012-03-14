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

    var img = Ti.UI.createImageView({
        image:'/struct/images/cu_denver_campus.png'
    });
    var simpleView = Ti.UI.createView({
      top: 200,
      left: 60,
      width: 50,
      height: 50,
      backgroundColor: 'red',
      zIndex: 1000
    });
    simpleView.addEventListener('click', function(e) {
      Ti.API.info('Simple view is a great start');
      Ti.API.info(e);
    })
    
    img.add(simpleView);
    
    var imgView = Ti.UI.createScrollView({
        maxZoomScale: 2.0
    });
    imgView.add(img);
    
    imgView.addEventListener('click', function(e) {
      Ti.API.info(e);
    })

    win.add(imgView);

		
		return win;
	};
})();

Ti.include("/struct/helpers/annotationHelpers.js");
//Ti.include("/struct/ui/clickview.js");