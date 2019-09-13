require("es5-shim");
var viewloader = require("viewloader");
var promoParamsLinkChecker = require("../public/promo-parameters");

var views = {};

var NavToggle = require("../public/nav-toggle");
views.navToggle = function(el, props) {
  new NavToggle(el, props);
};

// Kick things off
domready(function onDomReady() {
  viewloader.execute(views);
  promoParamsLinkChecker();
});
