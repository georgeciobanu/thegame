/**
* Appcelerator Titanium Platform
* Copyright (c) 2009-2011 by Appcelerator, Inc. All Rights Reserved.
* Licensed under the terms of the Apache Public License
* Please see the LICENSE included with this distribution for details.
**/
// Code is stripped-down version of Tweetanium, to expose new structure paradigm

(function(){
	Game.ui.createBarView = function(){
		var view = Ti.UI.createView({backgroundColor: "green"}),
			label = Ti.UI.createLabel(Game.ui.properties.Label);
		Ti.App.addEventListener("app:mood.update",function(e){
      label.text = "You are " + Game.app.mood+"!";
		});
		view.add(label);
		return view;
	};
})();