/**
 * Toggle the max-height value to get iOS to _force_ the iframe contained inside
 * the `el` here to overflow scroll.
 * @param  {Node} el The element to toggle
 */
function toggleMaxHeight(el) {
  var maxHeight = el.style.maxHeight;
  el.removeAttribute("style");
  // Force the browser to reevaluate the classes
  /* jshint ignore:start */
  el.offsetHeight;
  /* jshint ignore:end */
  el.style.maxHeight = maxHeight;
}

module.exports = function flarumEmbed(el, props) {
  var inner = el.querySelector(".flarum-discussion__inner");
  // Ridiculous hack to get iOS Safari to not be stupid.
  setTimeout(function() {
    toggleMaxHeight(inner);
  }, 5000);
};
