// callbacks can use code like this to access the response values:
// httpResponse = this.responseText;
// status = this.status;
Game.rest = {};
Game.rest.baseUrl = '';

Ti.API.info('Model is: ' + Titanium.Platform.model);

if (Titanium.Platform.model == 'x86_64' || Titanium.Platform.model == "Simulator") {
  Ti.API.info('Running on Simulator');
  Game.rest.baseUrl = 'http://localhost:3000/';
  //Game.rest.baseUrl = 'http://thegame-georgeciobanu.dotcloud.com/';
} else {
  Ti.API.info('Running on real device');
  Game.rest.baseUrl = 'http://thegame-georgeciobanu.dotcloud.com/';
}


Game.rest.callAPI = function(verb, url, callback, body) {
  url += '.json';
  // If verb === 'DELETE' we need to insert some stuff in the body
  // b/c Titanium sucks
  var client = Ti.Network.createHTTPClient( { timeout: 5000 } );
  client.onload = callback;
  client.onerror = function (e) {
    Ti.API.info('callAPI error callback');
    alert(e);
  }
  client.open(verb, Game.rest.baseUrl + url);
  
  // To see what body is when I don't pass a value for it
  Ti.API.info('body is:');
  Ti.API.info(body);
  client.send(body);
}