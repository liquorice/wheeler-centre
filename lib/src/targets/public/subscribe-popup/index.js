var tourist = require("../tourist");
var addClass = require("../utilities/add-class");

function SubscribePopup(el, props) {
  this.el = el;
  this.cookiePrefix = props.cookiePrefix || "subscribe-popup";
  var isRegistered = tourist.isRegistered(this.cookiePrefix);
  if (!isRegistered) {
    el.style.display = "block";
    // Register a standard view
    tourist.register(this.cookiePrefix);
  }
  var form = el.querySelector("form");
  var close = el.querySelector(".subscribe-popup__close");
  form.addEventListener("submit", this.onSubmit.bind(this));
  close.addEventListener("click", this.onCloseClick.bind(this));
}

SubscribePopup.prototype.onCloseClick = function(e) {
  e.preventDefault();
  tourist.register(this.cookiePrefix, true);
  addClass(this.el, ["subscribe-popup--hide"]);
};

SubscribePopup.prototype.onSubmit = function(e) {
  tourist.register(this.cookiePrefix, true);
};

module.exports = SubscribePopup;
