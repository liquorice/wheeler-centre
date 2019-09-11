require("es5-shim");
var viewloader = require("viewloader");

var views = {};

var NavToggle = require("../public/nav-toggle");
views.navToggle = function(el, props) {
  new NavToggle(el, props);
};

// Kick things off
domready(viewloader.execute.bind(this, views));
