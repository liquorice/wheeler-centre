var tourist = require("../tourist");
var addClass = require("../utilities/add-class");

function FooterTicker(el, props) {
  this.el = el;
  this.innerEl = el.querySelector(".ticker__inner");
  this.cookiePrefix = (props.cookiePrefix) ? props.cookiePrefix+"-footer-ticker" : "footer-ticker";
  var close = el.querySelector(".ticker__close");
  var isRegistered = tourist.isRegistered(this.cookiePrefix);
  if (!isRegistered) {
    el.style.display = "block";
    // Register a standard view
    tourist.register(this.cookiePrefix);
  } else if (props.force) {
    el.style.display = "block";
    close.parentNode.removeChild(close);
  }
  close.addEventListener("click", this.onCloseClick.bind(this));

  window.addEventListener("resize", this.onResize.bind(this));

}

FooterTicker.prototype.onCloseClick = function(e) {
  e.preventDefault();
  tourist.register(this.cookiePrefix, true);
  addClass(this.el, ["ticker--hide"]);
  this.innerEl.style.marginTop = this.el.offsetHeight + "px";
};

FooterTicker.prototype.onResize = function() {
  var scroller = this.el.querySelector(".ticker__scroller");
  var scrollerWrapper = this.el.querySelector(".ticker__scroller-wrapper");
  console.log(scrollerWrapper.offSetWidth);
  var duration = parseInt((1/scroller.offSetWidth) * 1000) + "s";
  console.log(duration);
  scroller.setAttribute("padding-right", scrollerWrapper.offSetWidth + "px");
  scroller.setAttribute("animation-duration", duration);
};

module.exports = FooterTicker;
