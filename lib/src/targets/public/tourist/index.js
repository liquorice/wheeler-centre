var cookie = require("component/cookie");

// A simple checker to see if a user is new in a certain context.
// For example, you might want to only show them a subscribe form if they
// haven't seen it before

function Tourist(options) {
  options = options || {};
  this.cookiePrefix = options.cookiePrefix || "tourist-";
  this.defaultStay  = options.defaultStay || (60 * 24 * 60 * 60 * 1000);
  this.registeredThreshold = options.registeredThreshold || 3;
}

// Check if there's a valid registration with the matching `name`
Tourist.prototype.isRegistered = function(name) {
  return parseFloat(cookie(this.cookiePrefix + name)) >= this.registeredThreshold;
};

// Set a cookie for a `name` with a `stay` in milliseconds
Tourist.prototype.register = function(name, complete, stay) {
  stay = stay || this.defaultStay;
  var count = parseFloat(cookie(this.cookiePrefix + name)) || 0;
  if (complete) {
    count = this.registeredThreshold;
  } else {
    count = count + 1;
  }
  cookie(this.cookiePrefix + name, count, {path: '/', maxage: stay});
};

var tourist = new Tourist();
module.exports = tourist;
