// playerjs is available as a global variable `playerjs`
require("../vendor/playerjs");
var reactive = require("reactive");
var hms = require("../hms");
var queryString = require("query-string");
var parseTime = require("../parse-time");
var TouchPreview = require("../touch-preview");
var trackEvent = require("../track-event");

var EVENT_CATEGORY = "video";

function iOS() {
  return ( navigator.userAgent.match(/(iPad|iPhone|iPod)/g) ? true : false );
}

function VideoPlayer(el, title) {
  this.el = el;
  this.model = {
    duration: [],
    loaded: false,
    playing: false
  };

  this.view = reactive(el, this.model, {
    // Delegate the reactive event handlers to this instance
    // see `on-click="onCoverClick" for example
    delegate: this,
    bindings: {
      "format-duration": this.formatDuration
    }
  });

  window.addEventListener("hashchange", this.moveToTimeHash.bind(this), false);

  // Set up the player
  this.iframe = this.el.querySelector("iframe");
  this.player = new playerjs.Player(this.iframe);

  // Set attributes for accessibility
  this.iframe.setAttribute('lang', document.documentElement.getAttribute('lang') || "en");
  this.iframe.setAttribute('title', title);

  // Bind player events
  this.player.on("ready", this.onPlayerReady.bind(this));
  this.player.on("ended", this.onPlayerEnded.bind(this));
  this.player.getDuration(this.onPlayerGetDuration.bind(this));

  // Event tracking
  this.player.on("timeupdate", this.trackWatchProgress.bind(this));
  this.player.on("play", this.trackPlay.bind(this));
  this.player.on("pause", this.trackPause.bind(this));

  // Manually bind the touch-preview because Reactive doesn't like
  // JSON in the data-attrs
  var teaserClassName = "video-player__teaser";
  var touchPreview = new TouchPreview(this.el.querySelector("."+teaserClassName), teaserClassName+"--preview");
}


VideoPlayer.prototype.onPlayerGetDuration = function(seconds) {
  this.view.set("duration", seconds * 1000);
};

VideoPlayer.prototype.onPlayerReady = function() {
  this.view.set("loaded", true);
  this.moveToTimeHash();
};

VideoPlayer.prototype.onPlayerEnded = function() {
  setTimeout(function() {
    this.view.set("playing", false);
  }.bind(this), 1000);
  trackEvent({
    category: EVENT_CATEGORY,
    action: "ended",
    label: this.iframe.src
  });
};

VideoPlayer.prototype.onTeaserClick = function(e) {
  e.preventDefault();
  this.view.set("playing", true);
  if (!iOS()) {
    this.player.play();
  }
};

VideoPlayer.prototype.onPlayerEnter = function(e) {
  console.log("here");
  e.preventDefault();
  this.view.set("playing", true);
  if (!iOS()) {
    this.player.play();
  }
};

// Watch the `property` and change the `el`
VideoPlayer.prototype.formatDuration = function(el, property) {
  var binding = this;
  binding.change(function() {
    var duration = hms(binding.value(property));
    el.innerText = duration.map(function(n) { return 10 > n ? '0' + n : n; }).join(':');
  });
};

// Transfer a location has like /video#t=1h15m10s into the video time
VideoPlayer.prototype.moveToTimeHash = function() {
  var hashParams = queryString.parse(location.hash);
  if (hashParams.t) {
    var time = parseTime(hashParams.t);
    if (time > 0 && this.model.duration <= time) {
      this.player.setCurrentTime(time);
      this.view.set("playing", true);
    }
  }
};

// Event tracking
// Track watch progress
var lastWatchedPercentage = 0;
var lastWatchedPercentageRounded = 0;
VideoPlayer.prototype.trackWatchProgress = function(data) {
  var watchedPercentage = Math.round(data.seconds / data.duration * 100);
  // Track 10% increments in a more obvious format
  var watchedPercentageRounded = Math.floor(watchedPercentage / 10) * 10;
  if (watchedPercentageRounded > lastWatchedPercentageRounded) {
    trackEvent({
      category: EVENT_CATEGORY,
      action: "watched " + watchedPercentageRounded + "%",
      label: this.iframe.src
    });
  }
  lastWatchedPercentageRounded = watchedPercentageRounded;
};

// Track play events
VideoPlayer.prototype.trackPlay = function(e) {
  trackEvent({
    category: EVENT_CATEGORY,
    action: "play",
    label: this.iframe.src
  });
};

// Track pause events
VideoPlayer.prototype.trackPause = function(e) {
  trackEvent({
    category: EVENT_CATEGORY,
    action: "pause",
    label: this.iframe.src
  });
};

// Export the creation function
module.exports = VideoPlayer;
