var addClass = require("../utilities/add-class");
var removeClass = require("../utilities/remove-class");

function AdoptAWordToggle(el, props) {
  this.active = false;
  this.buttonEl = el.querySelector("button");
  this.toggleEl = el.querySelector(".adopt-a-word__definition-wrapper");

  this.buttonEl.addEventListener("click", this.onButtonClick.bind(this));
} 

AdoptAWordToggle.prototype.onButtonClick = function(e) {
  e.preventDefault();
  if (this.active === false) {
    addClass(this.toggleEl, "adopt-a-word__definition-wrapper--active");
  } else {
    removeClass(this.toggleEl, "adopt-a-word__definition-wrapper--active");
  }
  this.active = !this.active;
};


module.exports = AdoptAWordToggle;
