var addClass = require("../utilities/add-class");
var removeClass = require("../utilities/remove-class");

function TouchPreview(el, props) {
  this.el = el;
  this.previewClassName = props.previewClassName;
  // Bind listeners
  this.el.addEventListener("touchstart", this.startPreview.bind(this));
  this.el.addEventListener("mouseover", this.startPreview.bind(this));
  this.el.addEventListener("touchend", this.endPreview.bind(this));
  this.el.addEventListener("touchmove", this.endPreview.bind(this));
  this.el.addEventListener("mouseout", this.endPreview.bind(this));
  // Bind focus/blur to the passed focusSelector
  if (props.focusSelector) {
    var focusElements = this.el.querySelectorAll(props.focusSelector);
    if (focusElements) {
      for (var i = focusElements.length - 1; i >= 0; i--) {
        focusElements[i].addEventListener("focus", this.startPreview.bind(this));
        focusElements[i].addEventListener("blur", this.endPreview.bind(this));
      }
    }
  } else {
    this.el.addEventListener("focus", this.startPreview.bind(this));
    this.el.addEventListener("blur", this.endPreview.bind(this));
  }
}

TouchPreview.prototype.startPreview = function(e) {
  addClass(this.el, this.previewClassName);
};

TouchPreview.prototype.endPreview = function(e) {
  removeClass(this.el, this.previewClassName);
};

module.exports = TouchPreview;
