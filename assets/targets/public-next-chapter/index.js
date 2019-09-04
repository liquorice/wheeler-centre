require("es5-shim");
var viewloader = require("viewloader");
var promoParamsLinkChecker = require("../public/promo-parameters");

var views = {};
var FontResizer = require("./font-resizer");
views.fontResizer = function(el, props) {
  new FontResizer(el, props);
};

// Kick things off
domready(function onDomReady() {
  viewloader.execute(views);
  promoParamsLinkChecker();
});
