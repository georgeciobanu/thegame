/**
* Appcelerator Titanium Platform
* Copyright (c) 2009-2011 by Appcelerator, Inc. All Rights Reserved.
* Licensed under the terms of the Apache Public License
* Please see the LICENSE included with this distribution for details.
**/

(function() {
	//create the login window
	Game.ui.createLoginWindow = function(_args) {
		var win = Ti.UI.createWindow(Game.combine(Game.ui.properties.Window, {
			exitOnClose:true,
			orientationModes:[Ti.UI.PORTRAIT]
		})),
		
		mainView = Ti.UI.createView({
			layout: 'vertical',
			backgroundColor: "blue"
		}),
		
		emailView = Ti.UI.createView({
		  layout: 'horizontal',
		  height: 50
		}),
		emailLabel = Ti.UI.createLabel({
		  text: 'Email:',
		  height: 20,
		  width: 70
		}),
		emailTextBox = Ti.UI.createTextField({
      color:'#336699',
      height:35,
      width:250,
      borderStyle: Titanium.UI.INPUT_BORDERSTYLE_ROUNDED		  
		}),
		
		passwordView = Ti.UI.createView({
		  layout: 'horizontal',
		  height: 50
		}),
		passwordLabel = Ti.UI.createLabel({
		  text: 'Password:',
		  height: 20,
		  width: 70
		}),
		passwordTextBox = Ti.UI.createTextField({
      color:'#336699',
      height:35,
      width:250,
      passwordMask: true,
      borderStyle: Titanium.UI.INPUT_BORDERSTYLE_ROUNDED
		}),
		
		loginButton = Ti.UI.createButton({
		  title: 'Play!',
		  height: 30,
		  width: 100,
      borderStyle:Titanium.UI.INPUT_BORDERSTYLE_ROUNDED		  
		});
		
		emailView.add(emailLabel);
		emailView.add(emailTextBox);
		
		passwordView.add(passwordLabel);
		passwordView.add(passwordTextBox);
		
		mainView.add(emailView);
		mainView.add(passwordView);
		
		loginButton.addEventListener('click', tryLogin);
		mainView.add(loginButton);

    function tryLogin (email, password) {
      Game.rest.callAPI('POST', '/users', processLoginResponse, {'email': emailTextBox.value, 'password': passwordTextBox.value});

      function processLoginResponse(e) {
        Ti.API.info('in onload');
        Ti.API.indo(this.responseText);
        response = JSON.parse(this.responseText);
        Ti.API.info(response);
      }
    }	
		
		win.add(mainView);
		return win;
	}
	
	
})();