// Singleton empty object we can require through the app
var views = {};

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
var NavToggle = require("../nav-toggle");
views.navToggle = function(el, props) {
  new NavToggle(el, props);
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

// People index bios
var PeopleIndexBio = require("../people-index-bio");
views.peopleIndexBio = function(el, props) {
  new PeopleIndexBio(el, props);
};

// People select box
var PeopleSelectBox = require("../people-select-box");
views.peopleSelectBox = function(el, props) {
  new PeopleSelectBox(el, props);
};

// HomeBanners
var HomeBanners = require("../home-banners");
views.homeBanners = function(el, props) {
  new HomeBanners(el, props);
};

// FastClick
var FastClick = require("fastclick");
views.fastClick = function(el, props) {
  new FastClick(el);
};

// SubscribePopup
var SubscribePopup = require("../subscribe-popup");
views.subscribePopup = function(el, props) {
  new SubscribePopup(el, props);
};

// CampaignBanner
var CampaignBanner = require("../campaign-banner");
views.campaignBanner = function(el, props) {
  new CampaignBanner(el, props);
};

// FooterTicker
var FooterTicker = require("../footer-ticker");
views.FooterTicker = function(el, props) {
  new FooterTicker(el, props);
};

// Search
var Search = require("../search");
views.search = function(el) {
  new Search(el);
};

// Select on focus
var selectOnFocus = require("../select-on-focus");
views.selectOnFocus = function(el) {
  selectOnFocus(el);
};

// Adopt a word toggle
var AdoptAWordToggle = require("../adopt-a-word");
views.adoptWordToggle = function(el, props) {
  new AdoptAWordToggle(el, props);
};

var iframeResizer = require("../vendor/iframe-resizer.js");
views.iframeResizer = function(el, props) {
  var iframe = iframeResizer(props, el);
};

var flarumEmbed = require("../flarum-embed");
views.flarumEmbed = flarumEmbed;

var flarumCommentCount = require("../flarum-comment-count");
views.flarumCommentCount = flarumCommentCount;

// Copy to clipboard
views.copyToClipboard = require("../copy-to-clipboard");

module.exports = views;
