function matches(el, selector) {
  return (el.matches || el.matchesSelector || el.msMatchesSelector || el.mozMatchesSelector || el.webkitMatchesSelector || el.oMatchesSelector).call(el, selector);
}

function dasherize(s) {
  return s.replace(/([a-z0-9])([A-Z])/g, "$1-$2").toLowerCase();
}

function parseProps(str) {
  var props = str;
  if (/^{/.test(str)) {
    props = JSON.parse(str);
  }
  return props;
}

function execute(views, scope, includeScope) {
  for(var view in views) {
    var dashView = dasherize(view);
    var selector = "[data-view-" + dashView + "]";
    var elements = [];
    if (scope) {
      var scopeLength = scope.length;
      // Iterate over `scope` if it's a NodeList
      if (scopeLength) {
        Array.prototype.forEach.call(scope, function(node, i) {
          elements.concat(node.querySelectorAll(selector));
          if (includeScope === true && matches(node, selector)) {
            elements.push(node);
          }
        });
      } else {
        elements = scope.querySelectorAll(selector);
        if (includeScope === true && matches(scope, selector)) {
          elements.push(scope);
        }
      }
    } else {
      elements = document.querySelectorAll(selector);
    }
    Array.prototype.forEach.call(elements, function(el, i) {
      views[view].call(this, el, parseProps(el.getAttribute("data-view-" + dashView)));
    });
  }
}

var viewloader = {
  execute: execute
};

module.exports = viewloader;
