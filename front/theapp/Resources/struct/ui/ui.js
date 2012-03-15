/**
* Appcelerator Titanium Platform
* Copyright (c) 2009-2011 by Appcelerator, Inc. All Rights Reserved.
* Licensed under the terms of the Apache Public License
* Please see the LICENSE included with this distribution for details.
**/
// Code is stripped-down version of Tweetanium, to expose new structure paradigm

(function(){
	var userColor;
	
	Game.ui = {};
  Game.ui.selected_id = -1;
	
	Game.ui.setUserColor = function(color){
		Ti.API.info("Setting user color to: " + color);
		userColor = color;
	};
	
	Game.ui.getUserColor = function(){
		return userColor;
	};
	
	//create a film strip like view 
	Game.ui.createFilmStripView = function(_args) {
		var root = Ti.UI.createView(Game.combine(Game.ui.properties.stretch,_args)),
		views = _args.views,
		container = Ti.UI.createView({
			top:0,
			left:0,
			bottom:0,
			width:Game.ui.properties.platformWidth*_args.views.length
		});

		for (var i = 0, l = views.length; i<l; i++) {
			var newView = Ti.UI.createView({
				top:0,
				bottom:0,
				left:Game.ui.properties.platformWidth*i,
				width:Game.ui.properties.platformWidth
			});
			newView.add(views[i]);
			container.add(newView);
		}
		root.add(container);
		
		//set the currently visible index
		root.addEventListener('changeIndex', function(e) {
			var leftValue = Game.ui.properties.platformWidth*e.idx*-1;
			container.animate({
				duration:Game.ui.properties.animationDuration,
				left:leftValue
			});
		});
		
		return root;
	};
}());

Ti.include("/struct/ui/mapWindow.js");
Ti.include("/struct/ui/login.js");
Ti.include("/struct/ui/styles.js");
Ti.include("/struct/ui/tabGroup.js");
Ti.include("/struct/ui/fooview.js");
Ti.include("/struct/ui/barview.js");
Ti.include("/struct/ui/bazview.js");