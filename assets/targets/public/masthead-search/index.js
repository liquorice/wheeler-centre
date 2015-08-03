var addClass = require("../utilities/add-class");
var removeClass = require("../utilities/remove-class");

function MastheadSearch(el, props) {
  this.toggleEl = el.querySelector(props.toggleSelector);
  this.targetEl = el.querySelector(props.targetSelector);
  this.closeEl = el.querySelector(props.closeSelector);
  this.activeClass = props.targetActiveClassName;

  this.toggleEl.addEventListener("click", this.open.bind(this));
  this.closeEl.addEventListener("click", this.close.bind(this));
  window.addEventListener("keyup", this.onKeyUp.bind(this));
}

MastheadSearch.prototype.open = function(e) {
  e.preventDefault();
  addClass(this.targetEl, this.activeClass);
};

MastheadSearch.prototype.close = function(e) {
  removeClass(this.targetEl, this.activeClass);
  window.removeEventListener("keyup", this.onKeyUp.bind(this));
};

MastheadSearch.prototype.onKeyUp = function(e) {
  if (e.keyCode === 27) {
    this.close();
  }
};

module.exports = MastheadSearch;
