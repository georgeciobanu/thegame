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
	Game.ui.createTabGroup = function(_args) {

		var win = Ti.UI.createWindow(Game.combine(Game.ui.properties.Window,{
			exitOnClose:true,
			orientationModes:[Ti.UI.PORTRAIT]
		})),		
		tabGroup = Ti.UI.createTabGroup();
    tabGroup.addTab(Ti.UI.createTab({window: win, title: 'Map'}));
    
		var win2 = Ti.UI.createWindow(Game.combine(Game.ui.properties.Window,{
			orientationModes:[Ti.UI.PORTRAIT]
		}));

    tabGroup.addTab(Ti.UI.createTab({window: win2, title: 'Summon minions'}));
		

		// add msg view
		var msgview = Ti.UI.createView({opacity:0,zIndex:10,width:platformWidth-100,left:50,top:230,height:100}),
			msglabel = Ti.UI.createLabel(Game.ui.properties.Label);
		msgview.add(msglabel);
		Ti.App.addEventListener("app:msg",function(e){
			Ti.API.log(e);
			msglabel.text = e.msg;
			msgview.backgroundColor = e.error ? "red" : "white";
			msgview.opacity = 1;
			msgview.animate({
				opacity: 0,
				duration: 1500
			});
		});
		win.add(msgview);
		
		//assemble main app window
    // win.add(appFilmStrip);

		return tabGroup;
	};
})();