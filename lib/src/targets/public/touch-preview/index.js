var addClass = require("../utilities/add-class");
var removeClass = require("../utilities/remove-class");

function TouchPreview(el, previewClassName) {
  this.el = el;
  this.previewClassName = previewClassName;
  // Bind listeners
  this.el.addEventListener("touchstart", this.startPreview.bind(this));
  this.el.addEventListener("mouseover", this.startPreview.bind(this));
  this.el.addEventListener("touchend", this.endPreview.bind(this));
  this.el.addEventListener("touchmove", this.endPreview.bind(this));
  this.el.addEventListener("mouseout", this.endPreview.bind(this));
}

TouchPreview.prototype.startPreview = function(e) {
  addClass(this.el, this.previewClassName);
};

TouchPreview.prototype.endPreview = function(e) {
  removeClass(this.el, this.previewClassName);
};

module.exports = TouchPreview;
