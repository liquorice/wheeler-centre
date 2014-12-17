var VideoPlayer = require("../video-player");

// Singleton empty object we can require through the app
var views = {};

// Masthead can just be assigned directly to the view we use it in
views.masthead = require("../masthead");

// Add viewPlayer to the called views
views.videoPlayer = function(el, props) {
  return new VideoPlayer(el, props);
// TouchPreview
var TouchPreview = require("../touch-preview");
views.touchPreview = function(el, previewClassName) {
  new TouchPreview(el, previewClassName);
};

module.exports = views;
