/**
* Appcelerator Titanium Platform
* Copyright (c) 2009-2011 by Appcelerator, Inc. All Rights Reserved.
* Licensed under the terms of the Apache Public License
* Please see the LICENSE included with this distribution for details.
**/
// Code is stripped-down version of Tweetanium, to expose new structure paradigm

(function(){
	Game.ui.createFooView = function(){
		var view = Ti.UI.createView({backgroundColor: "red"});
		view.add(Ti.UI.createLabel(Game.combine({text: "See blogpost @ http://blog.krawaller.se"}, Game.ui.properties.Label)));
		return view;
	};
})();