require("es5-shim");
var viewloader = require("viewloader");

// Construct only TNEW template relevant views
var views = {};

var FastClick = require("fastclick");
views.fastClick = function(el, props) {
  new FastClick(el);
};

var MastheadEvents = require("../public/masthead-events");
views.mastheadEvents = function(el, props) {
  new MastheadEvents(el, props);
};

var MastheadSearch = require("../public/masthead-search");
views.mastheadSearch = function(el, props) {
  new MastheadSearch(el, props);
};

var NavToggle = require("../public/nav-toggle");
views.navToggle = function(el, props) {
  new NavToggle(el, props);
};

// Search
var Search = require("../public/search");
views.search = function(el) {
  new Search(el);
};

var TouchPreview = require("../public/touch-preview");
views.touchPreview = function(el, previewClassName) {
  new TouchPreview(el, previewClassName);
};


// Kick things off
domready(function onDomReady() {
  viewloader.execute(views);

  // Redirect my.wheelercentre.com/events to www.wheelercentre.com/events
  if (window.location.pathname === "/events") {
    window.location = "https://www.wheelercentre.com/events";
  }
});
