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
	
  // initialize the module  
  var nfm = require('netfunctional.mapoverlay');  

  // #create the map view
  var mapview = nfm.createMapView({  
      mapType: Titanium.Map.STANDARD_TYPE,  
      animate:true,  
      region: {  
           latitude:33.126865,  
           longitude:-117.266847,  
           latitudeDelta:100,  
           longitudeDelta:100  
      },  
  });

  // #First create an object defining the properties of our overlay
  var polyOverlayDef = {
      name:"pOverlay1",
      type:"polygon",
      points:[
          {latitude: 32.259265  ,longitude:-64.863281},
          {latitude: 18.354526  ,longitude:-66.049805},
          {latitude: 25.839449  ,longitude:-80.244141}
      ],
      strokeColor: "purple",
      strokeAlpha: 0.9,
      fillColor: "blue",
      fillAlpha: 0.5
  };

  // #Call the addOverlay function of our `netfunctional.mapoverlay.MapView` object with the data for our polygon overlay as parameter
  mapview.addOverlay(polyOverlayDef);
  
  //#First create an object defining the properties of our overlay
  var circleOverlayDef = {
      name:"broadcastRange",
      type:"circle",
      center:{latitude:42.814243,
          longitude:-73.939569
      },
      radius:160000, //approximates 1000 miles
      strokeColor: "red",
      strokeAlpha: 0.9,
      fillColor: "orange",
      fillAlpha: 0.5,
      width:1
  };

  // #Call the addOverlay function of our `netfunctional.mapoverlay.MapView` object with the data for our circle overlay as parameter
  mapview.addOverlay(circleOverlayDef);
  

  // #add the mapview to your window
  win.add(mapview);

	return win;
	};
})();