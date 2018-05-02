function FontResizer(el, props) {
  var fontResizingEl = document.querySelector(props.fontResizingSelector);
  var buttons = props.buttons.map(function(button) { return {el: el.querySelector(button.selector), fontSize: button.fontSize}; });
  buttons.map(function(button) {
    button.el.addEventListener("click", function(e) {
      fontResizingEl.style.fontSize = button.fontSize;
      buttons.map(function(b) { b.el.classList.remove(props.activeClass); });
      button.el.classList.add(props.activeClass);
    });
  });
}

module.exports = FontResizer;
