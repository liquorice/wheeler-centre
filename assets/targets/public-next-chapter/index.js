require("es5-shim");
var viewloader = require("viewloader");

var views = {};
var FontResizer = require("./font-resizer");
views.fontResizer = function(el, props) {
  new FontResizer(el, props);
};

// Kick things off
domready(viewloader.execute.bind(this, views));
