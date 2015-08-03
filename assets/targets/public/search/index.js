function Search(el) {
  this.hiddenSearchEl = el.querySelector(".search__input.hidden");
  this.updateSearchQuery();
}

Search.prototype.updateSearchQuery = function() {
  if (this.hiddenSearchEl) {
    this.mastheadSearchEl = document.querySelector(".masthead-nav-secondary__search-input");
    this.footerSearchEl = document.querySelector(".footer__search-input");

    this.mastheadSearchEl.value = this.hiddenSearchEl.value;
    this.footerSearchEl.value = this.hiddenSearchEl.value;
  }
};

module.exports = Search;