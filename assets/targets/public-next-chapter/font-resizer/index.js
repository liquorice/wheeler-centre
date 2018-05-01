function FontResizer(el, props) {
  var fontSizedEl = document.querySelector(props.fontSizedElSelector);
  var smallButton = el.querySelector(props.smallButtonSelector);
  var normalButton = el.querySelector(props.normalButtonSelector);
  var largeButton = el.querySelector(props.largeButtonSelector);
  var buttons = [{el: smallButton, fontsize: "57.5%"}, {el: normalButton, fontsize: "62.5%"}, {el: largeButton, fontsize: "67.5%"}];
  buttons.map(function(button) {
    button.el.addEventListener("click", function(e) {
      fontSizedEl.style.fontSize = button.fontsize;
      buttons.map(function(b) { b.el.classList.remove("nc-font-size--active"); });
      button.el.classList.add("nc-font-size--active");
    });
  });
}

module.exports = FontResizer;
