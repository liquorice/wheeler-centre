var tourist = require("../tourist");
var addClass = require("../utilities/add-class");

function CampaignBanner(el, props) {
  this.el = el;
  this.cookiePrefix = (props.cookiePrefix) ? props.cookiePrefix+"-campaign-banner" : "campaign-banner";
  var isRegistered = tourist.isRegistered(this.cookiePrefix);
  if (!isRegistered) {
    el.style.display = "block";
    // Register a standard view
    tourist.register(this.cookiePrefix);
  } else if (props.force) {
    el.style.display = "block";
  }
  if (this.el.nodeName === "A") {
    this.el.addEventListener("click", this.onClick.bind(this), false);
  }
}

CampaignBanner.prototype.onClick = function(e) {
  tourist.register(this.cookiePrefix, true);
};


module.exports = CampaignBanner;
