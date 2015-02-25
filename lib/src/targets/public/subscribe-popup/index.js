var tourist = require("../tourist");
var addClass = require("../utilities/add-class");

function SubscribePopup(el, props) {
  this.el = el;
  this.innerEl = el.querySelector(".subscribe-popup__inner");
  this.cookiePrefix = (props.cookiePrefix) ? props.cookiePrefix+"subscribe-popup-" : "subscribe-popup";
  var form = el.querySelector("form");
  var close = el.querySelector(".subscribe-popup__close");
  var isRegistered = tourist.isRegistered(this.cookiePrefix);
  if (!isRegistered) {
    el.style.display = "block";
    // Register a standard view
    tourist.register(this.cookiePrefix);
  } else if (props.force) {
    el.style.display = "block";
    close.parentNode.removeChild(close);
  }
  form.addEventListener("submit", this.onSubmit.bind(this));
  close.addEventListener("click", this.onCloseClick.bind(this));
}

SubscribePopup.prototype.onCloseClick = function(e) {
  e.preventDefault();
  tourist.register(this.cookiePrefix, true);
  addClass(this.el, ["subscribe-popup--hide"]);
  this.innerEl.style.marginTop = this.el.offsetHeight * -1 + "px";
};

SubscribePopup.prototype.onSubmit = function(e) {
  tourist.register(this.cookiePrefix, true);
};

module.exports = SubscribePopup;
