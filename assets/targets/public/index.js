require("es5-shim");
var picturefill = require("picturefill");
var viewloader = require("viewloader");
var promoParamsLinkChecker = require("./promo-parameters");

// App specific components
var views = require("./views");

// Kick things off
domready(function onDomReady() {
  viewloader.execute(views);
  promoParamsLinkChecker();
});
