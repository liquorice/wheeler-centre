// Simple wrapper for Google Analytics event tracking
// https://developers.google.com/analytics/devguides/collection/analyticsjs/events
function trackEvent(event) {
  if (!ga) return;
  var meta = {
    "page": window.location.pathname
  };
  ga("send", "event", event.category, event.action, event.label, event.value, meta);
}

module.exports = trackEvent;
