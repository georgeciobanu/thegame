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
			exitOnClose: false,
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
		emailTextBox = Ti.UI.createTextField({
      color:'#336699',
      height:35,
      width:250,
      hintText: 'Email',
      value: 'liviu@lh.com',
      borderStyle: Titanium.UI.INPUT_BORDERSTYLE_ROUNDED		  
		}),
		
		passwordView = Ti.UI.createView({
		  layout: 'horizontal',
		  height: 50
		}),
		passwordTextBox = Ti.UI.createTextField({
      color:'#336699',
      height:35,
      width:250,
      passwordMask: true,
      hintText: 'Password',
      value: 'password',
      borderStyle: Titanium.UI.INPUT_BORDERSTYLE_ROUNDED
		}),
		
		loginButton = Ti.UI.createButton({
		  title: 'Play!',
		  height: 30,
		  width: 100,
      borderStyle:Titanium.UI.INPUT_BORDERSTYLE_ROUNDED		  
		});
		
		emailView.add(emailTextBox);
		passwordView.add(passwordTextBox);
		
		mainView.add(emailView);
		mainView.add(passwordView);
		
		loginButton.addEventListener('click', tryLogin);
		mainView.add(loginButton);

    function tryLogin (email, password) {
      Game.rest.callAPI('POST', '/users', processLoginResponse, {'email': emailTextBox.value, 'password': passwordTextBox.value});

      function processLoginResponse(e) {
        Ti.API.info('in onload');
        response = JSON.parse(this.responseText);
        // if (response.result === 'login' || response.result === 'new') {
          Game.app.mainWindow = Game.ui.createTabGroup();
          Game.app.mainWindow.open();
          win.close();
        // }
      }
    }	

		win.add(mainView);
		return win;
	}
	
	
})();