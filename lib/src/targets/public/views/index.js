// Singleton empty object we can require through the app
var views = {};

// Masthead can just be assigned directly to the view we use it in
views.masthead = require("../masthead");

// Add VideoPlayer to the called views
var VideoPlayer = require("../video-player");
views.videoPlayer = function(el, props) {
  new VideoPlayer(el, props);
};

// Add AudioPlayer to the called views
var AudioPlayer = require("../audio-player");
views.audioPlayer = function(el, props) {
  new AudioPlayer(el, props);
};

// TouchPreview
var TouchPreview = require("../touch-preview");
views.touchPreview = function(el, previewClassName) {
  new TouchPreview(el, previewClassName);
};

// Event page
var EventPage = require("../event");
views.event = function(el, props) {
  new EventPage(el, props);
};

// Venue page
var VenuePage = require("../venue");
views.venue = function(el, props) {
  new VenuePage(el, props);
};

// Event venue map
var EventVenueMap = require("../event-venue-map");
views.eventVenueMap = function(el, props) {
  new EventVenueMap(el, props);
};

// Masthead navigation
var MastheadNavigation = require("../masthead-navigation");
views.mastheadNavigation = function(el, props) {
  new MastheadNavigation(el, props);
};

// Masthead search
var MastheadSearch = require("../masthead-search");
views.mastheadSearch = function(el, props) {
  new MastheadSearch(el, props);
};

// Masthead events
var MastheadEvents = require("../masthead-events");
views.mastheadEvents = function(el, props) {
  new MastheadEvents(el, props);
};

// Grouper
var Grouper = require("../grouper");
views.grouper = function(el, props) {
  new Grouper(el, props);
};

// SubscribeForm
var SubscribeForm = require("../subscribe");
views.subscribeForm = function(el, props) {
  new SubscribeForm(el, props);
};

// People index
var PeopleIndexBio = require("../masthead-events");
views.peopleIndexBio = function(el, props) {
  new PeopleIndexBio(el, props);
};

// HomeBanners
var HomeBanners = require("../home-banners");
views.homeBanners = function(el, props) {
  new HomeBanners(el, props);
};

module.exports = views;
