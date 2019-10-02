var cookie = require("component-cookie");
var delegate = require("delegate");
var Url = require("url-parse");

var COOKIE_NAME = "promo-parameter";
var COOKIE_MAX_AGE_IN_MS = 3 * 24 * 60 * 60 * 1000;
var parsedURL = new Url(window.location, true);
if (parsedURL.query.promo != null) {
  cookie(COOKIE_NAME, parsedURL.query.promo, {
    path: "/",
    domain: ".wheelercentre.com", // This ensures we share across domains but will stop things working locally
    maxage: COOKIE_MAX_AGE_IN_MS
  });
}

// Intercept all link clicks
function onLinkClick(e) {
  // Check if there’s a promo code
  var promoCode = cookie(COOKIE_NAME);
  if (promoCode == null) {
    return;
  }
  // Extract URL
  var parsedLinkURL = new Url(e.delegateTarget.href, true);
  var openInNewWindow =
    e.metaKey ||
    e.ctrlKey ||
    e.delegateTarget.getAttribute("target") === "_blank";
  // Intercept any links to my.wheelercentre.com
  if (parsedLinkURL.hostname === "my.wheelercentre.com") {
    e.preventDefault();
    parsedLinkURL.set(
      "query",
      Object.assign({}, parsedLinkURL.query, { promo: promoCode, premove: "Y" })
    );
    visitLink(parsedLinkURL.toString(), openInNewWindow);
  } else if (
    // Intercept any links to my.wheelercentre.com _through_ track.wheelercentre.com
    parsedLinkURL.hostname === "track.wheelercentre.com" &&
    parsedLinkURL.query &&
    /http?s\:\/\/my\.wheelercentre\.com/.test(parsedLinkURL.query.target)
  ) {
    e.preventDefault();
    // Extract then set the params in the `target` URL
    var parsedTrackingTargetURL = new Url(parsedLinkURL.query.target);
    parsedTrackingTargetURL.set(
      "query",
      Object.assign({}, parsedTrackingTargetURL.query, { promo: promoCode, premove: "Y" })
    );
    // Then set that value in the tracking URL
    parsedLinkURL.set(
      "query",
      Object.assign({}, parsedLinkURL.query, {
        target: parsedTrackingTargetURL.toString()
      })
    );
    visitLink(parsedLinkURL.toString(), openInNewWindow);
  }
}

// Effect a link visit
function visitLink(url, openInNewWindow) {
  if (openInNewWindow) {
    window.open(url);
  } else {
    window.location = url;
  }
}

module.exports = function promoParamsLinkChecker() {
  delegate(document, "a", "click", onLinkClick);
};
