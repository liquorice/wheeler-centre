// Singleton empty object we can require through the app
var views = {};

// Add AudioPlayer to the called views
var AudioPlayer = require("../../public/audio-player");
views.audioPlayer = function(el, props) {
  new AudioPlayer(el, props);
};

module.exports = views;
