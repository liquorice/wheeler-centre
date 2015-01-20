// Singleton empty object we can require through the app
var views = {};

// Masthead can just be assigned directly to the view we use it in
views.masthead = require("../masthead");

// Add VideoPlayer to the called views
var VideoPlayer = require("../video-player");
views.videoPlayer = function(el, props) {
  new VideoPlayer(el, props);
};

// TouchPreview
var TouchPreview = require("../touch-preview");
views.touchPreview = function(el, previewClassName) {
  new TouchPreview(el, previewClassName);
};

// Event venue map
var EventVenueMap = require("../event-venue-map");
views.eventVenueMap = function(el, props) {
  new EventVenueMap(el, props);
};

module.exports = views;
