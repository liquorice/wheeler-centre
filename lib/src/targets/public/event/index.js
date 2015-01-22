function EventPage(el, props) {
  this.seriesEl = el.querySelector(".event__series-summary");
  this.presentersEl = el.querySelector(".event__presenters");
  this.checkSeriesPosition();
}

EventPage.prototype.checkSeriesPosition = function() {
  if (this.seriesEl && this.presentersEl) {
    var seriesBottom = this.seriesEl.getBoundingClientRect().top + this.seriesEl.offsetHeight;
    var presentersBottom = this.presentersEl.getBoundingClientRect().top + this.presentersEl.offsetHeight;
    if (seriesBottom > presentersBottom) {
      this.seriesEl.style.clear = "both";
    }
  }
};

module.exports = EventPage;
