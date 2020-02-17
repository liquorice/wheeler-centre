//= require jquery

(function() {

  function showPageActions(element, className) {
    element.toggleClass(className);
  }

  // Add to Heracles.views
  window.HeraclesAdmin.views.showPageActions = function($el, el, props) {
    var button = $el.find(props.buttonSelector);
    var pullOut = $el.find(props.pullOutSelector);
    button.on("click", function(e) {
      e.preventDefault();
      showPageActions(pullOut, props.pullOutSelector.replace(/\./, "") + "--active");
    });
  }

}).call(this);
