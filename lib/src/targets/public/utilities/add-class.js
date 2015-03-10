function addClass(el, classNames) {
  if (!classNames) return;
  if (classNames.constructor !== Array) {
    classNames = [classNames];
  }
  if (el.classList) {
    classNames.forEach(function(className) {
      el.classList.add(className);
    });
  } else {
    el.className += ' ' + className.join(" ");
  }
}

module.exports = addClass;
