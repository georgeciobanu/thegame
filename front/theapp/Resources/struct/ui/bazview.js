/**
* Appcelerator Titanium Platform
* Copyright (c) 2009-2011 by Appcelerator, Inc. All Rights Reserved.
* Licensed under the terms of the Apache Public License
* Please see the LICENSE included with this distribution for details.
**/
// Code is stripped-down version of Tweetanium, to expose new structure paradigm

(function(){
	Game.ui.createBazView = function(){
		var view = Ti.UI.createView({backgroundColor: "blue"}),
			textbox = Ti.UI.createTextField(Game.combine({top:50,left:10,right:10,value:"radiant"},Game.ui.properties.TextField)),
			button = Ti.UI.createButton(Game.combine({title:"Become!",top:130,height:30,width:150},Game.ui.properties.button));
		button.addEventListener("click",function(){
			textbox.blur();
			if (!textbox.value){
				Ti.App.fireEvent("app:msg",{msg:"Must enter a mood!",error:true});
				return;
			}
			if (textbox.value === Game.app.mood){
        Ti.App.fireEvent("app:msg",{msg:"You already are " + Game.app.mood+"!",error:true});
				return;
			}
			Game.app.mood = textbox.value;
      Ti.API.log("MOOD SET TO " + Game.app.mood);
			Ti.App.fireEvent("app:mood.update");
			Ti.App.fireEvent("app:msg",{msg:"Awright! :)"});
		});
		view.add(textbox);
		view.add(button); 
		return view;
	};
})();