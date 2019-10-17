var cookie = require("component-cookie");
var delegate = require("delegate");
var Url = require("url-parse");

COOKIE_DOMAIN = "localhost";
var PROMO_COOKIE_NAME = "promo-parameter";
var PROMO_COOKIE_MAX_AGE_IN_MS = 3 * 24 * 60 * 60 * 1000;
var CLICKED_COOKIE_NAME = "promo-last-clicked";
var CLICKED_COOKIE_MAX_AGE_IN_MS = 1 * 60 * 60 * 1000;

// Set the promo parameter from the URL
var parsedURL = new Url(window.location, true);
if (parsedURL.query.promo != null) {
  cookie(PROMO_COOKIE_NAME, parsedURL.query.promo, {
    path: "/",
    domain: COOKIE_DOMAIN, // This ensures we share across domains but will stop things working locally
    maxage: PROMO_COOKIE_MAX_AGE_IN_MS
  });
}

// Intercept all link clicks
function onLinkClick(e) {
  // Check if there’s a promo code
  var promoCode = cookie(PROMO_COOKIE_NAME);
  var clickedCode = cookie(CLICKED_COOKIE_NAME);

  // Don’t send the params to TNEW if:
  // - there’s no code, duh
  // - the promo code matches the one clicked within the last hour
  if (promoCode == null || promoCode === clickedCode) {
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
    visitLink(parsedLinkURL.toString(), promoCode, openInNewWindow);
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
    visitLink(parsedLinkURL.toString(), promoCode, openInNewWindow);
  }
}

function setClickedCookie(clickedCode) {
  cookie(CLICKED_COOKIE_NAME, clickedCode, {
    path: "/",
    domain: COOKIE_DOMAIN, // This ensures we share across domains but will stop things working locally
    maxage: CLICKED_COOKIE_MAX_AGE_IN_MS
  });
}

// Effect a link visit
function visitLink(url, code, openInNewWindow) {
  setClickedCookie(code);
  if (openInNewWindow) {
    window.open(url);
  } else {
    window.location = url;
  }
}

module.exports = function promoParamsLinkChecker() {
  delegate(document, "a", "click", onLinkClick);
};
