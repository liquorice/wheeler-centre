/**
 * Select the entirety of an `el` when `focus` is called
 * @param  {Node} el The element we want to focus
 * @return {Void}
 */
module.exports = function selectOnFocus(el) {
  el.addEventListener("focus", function(e) {
    el.select();
  });
};