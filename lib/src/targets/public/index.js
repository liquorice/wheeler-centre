var viewloader = require("./viewloader");
var views = require("./views");

// App specific components
var mastead = require("./masthead");

// Kick things off
domready(viewloader.execute.bind(this, views));
