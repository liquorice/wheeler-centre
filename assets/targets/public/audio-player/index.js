var reactive = require("reactive");
var Draggabilly = require("imports?define=>false!draggabilly");
var hms = require("../hms");
var TouchPreview = require("../touch-preview");
var trackEvent = require("../track-event");

var EVENT_CATEGORY = "audio";

function AudioPlayer(el, props) {
  this.el = el;
  this.handleEl = this.el.querySelector(".audio-player__handle");
  // Extract the duration from a data-attr if we can
  var duration = this.el.getAttribute("data-audio-player-duration") || 0;
  this.model = {
    duration: duration,
    currentTime: 0,
    metaDataLoaded: (duration > 0),
    playing: false,
    has_played: false,
    loadStarted: false,
    loadProgress: 0,
    playProgress: 0,
    trackPosition: 0,
    elementWidth: 0,
    isDragging: false,
    embedVisible: false
  };

  this.view = reactive(el, this.model, {
    // Delegate the reactive event handlers to this instance
    // see `on-click="onCoverClick" for example
    delegate: this,
    bindings: {
      "format-duration": this.formatDuration,
      "format-track-position": this.formatTrackPosition,
      "format-load-position": this.formatLoadPosition,
      "format-handle-position": this.formatHandlePosition,
      "format-faker-bar": this.formatFakerBar
    }
  });

  // Handle
  this.setupDragHandle();
  window.addEventListener("resize", this.onResize.bind(this), false);
  this.handle.on("dragStart", this.onHandleDragStart.bind(this));
  this.handle.on("dragMove", this.onHandleDrag.bind(this));
  this.handle.on("dragEnd", this.onHandleDragEnd.bind(this));

  // Set up the player
  this.player = el.querySelector("audio");
  this.player.addEventListener("loadedmetadata", this.onMetadataLoaded.bind(this));
  this.player.addEventListener("timeupdate", this.onTimeUpdate.bind(this));
  this.player.addEventListener("timeupdate", this.trackWatchProgress.bind(this));
  this.player.addEventListener("ended", this.onEnded.bind(this));
}


AudioPlayer.prototype.onResize = function() {
  this.setupDragHandle();
};


AudioPlayer.prototype.setupDragHandle = function() {
  var handleWidth = 40;
  var handleOffset = handleWidth / 2;
  this.view.set("elementWidth", this.el.offsetWidth);
  // Reinitialise
  this.handle = new Draggabilly(this.handleEl, {
    axis: "x",
    containment: this.el
    // range: {
    //   x: [0 + handleOffset, this.model.elementWidth - handleOffset]
    // }
  });
  // Reposition the handle inside parent if it overflows
  this.handleEl.style.left = (this.model.elementWidth * this.model.trackPosition) + "px";
};

AudioPlayer.prototype.onMetadataLoaded = function(e) {
  this.view.set("metaDataLoaded", true);
  this.view.set("duration", this.player.duration);
};

AudioPlayer.prototype.onEnded = function(e) {
  this.view.set("playing", false);
  this.view.set("has_played", false);
  this.view.set("currentTime", 0);
  this.view.set("playProgress", 0);
  this.view.set("trackPosition", 0);
  trackEvent({
    category: EVENT_CATEGORY,
    action: "audio, ended"
  });
};

// Watch the `property` and change the `el`
AudioPlayer.prototype.formatDuration = function(el, property) {
  var binding = this;
  binding.change(function() {
    var duration = hms(binding.value(property) * 1000);
    el.innerHTML = duration.map(function(n) { return 10 > n ? '0' + n : n; }).join(':');
  });
};

AudioPlayer.prototype.formatTrackPosition = function(el, property) {
  var binding = this;
  binding.change(function() {
    var trackPosition = binding.value(property) || 0;
    el.style.width = (trackPosition * 100) + "%";
  });
};

AudioPlayer.prototype.formatLoadPosition = function(el, property) {
  var binding = this;
  binding.change(function() {
    var loadProgress = binding.value(property) || 0;
    el.style.width = (loadProgress * 100) + "%";
  });
};

AudioPlayer.prototype.formatFakerBar = function(el, property) {
  var binding = this;
  binding.change(function() {
    el.style.height = (Math.random() * 100) + "%";
  });
};

AudioPlayer.prototype.formatHandlePosition = function(el, property) {
  var binding = this;
  binding.change(function() {
    var trackPosition = binding.value(property) || 0;
    el.style.left = (this.model.elementWidth * trackPosition) + "px";
  });
};

AudioPlayer.prototype.onPlayClick = function(e) {
  e.preventDefault();
  this.player.play();
  this.view.set("playing", true);
  if (!this.model.loadStarted) {
    this.view.set("loadStarted", true);
    this.loadInterval = setInterval(this.watchLoadProgress.bind(this), 200);
  }
  if ( this.model.has_played === true ) {
    trackEvent({
      category: EVENT_CATEGORY,
      action: "audio, play — click"
    });
  } else {
    trackEvent({
      category: EVENT_CATEGORY,
      action: "audio, started"
    });
  }
};

AudioPlayer.prototype.watchLoadProgress = function() {
  if (this.player.buffered !== null && this.player.buffered.length) {
    var durationLoaded = this.player.buffered.end(this.player.buffered.length - 1);
    if (this.model.duration > 0) {
      var loadPercentage = durationLoaded / this.model.duration;
      this.view.set("loadProgress", loadPercentage);
      if(loadPercentage >= 1) {
        clearInterval(this.loadInterval);
      }
    }
  }
};

AudioPlayer.prototype.onPauseClick = function(e) {
  e.preventDefault();
  this.player.pause();
  this.view.set("playing", false);
  this.view.set("has_played", true);
  trackEvent({
    category: EVENT_CATEGORY,
    action: "audio, pause — click"
  });
};

AudioPlayer.prototype.onTimeUpdate = function(e) {
  this.view.set("currentTime", this.player.currentTime);
  this.setPlayProgressByTime(this.model.currentTime);
};

AudioPlayer.prototype.setPlayProgressByTime = function(currentTime) {
  if (!this.model.isDragging) {
    var duration = this.model.duration || 0;
    currentTime = currentTime || 0;
    var playProgress = currentTime / duration;
    this.view.set("playProgress", playProgress);
    this.view.set("trackPosition", playProgress);
  }
};

AudioPlayer.prototype.setHandlePosition = function() {
  // Set the trackPosition and the playProgress based on % across
  var percentagePosition = this.handleEl.offsetLeft / this.model.elementWidth;
  percentagePosition = (percentagePosition > 1) ? 1 : percentagePosition;
  this.view.set("playProgress", percentagePosition);
  this.view.set("trackPosition", percentagePosition);
  return percentagePosition;
};

AudioPlayer.prototype.onHandleDragStart = function(e) {
  this.view.set("isDragging", true);
};

AudioPlayer.prototype.onHandleDrag = function(e) {
  var percentagePosition = this.setHandlePosition();
};

AudioPlayer.prototype.onHandleDragEnd = function(e) {
  var percentagePosition = this.setHandlePosition();
  // Set the playing time
  this.player.currentTime = this.model.duration * percentagePosition;
  this.view.set("isDragging", false);
};

/**
 * toggleEmbedVisibility
 */
AudioPlayer.prototype.toggleEmbedVisibility = function(e) {
  var visible = !this.view.get("embedVisible");
  this.view.set("embedVisible", visible);
};



// Event tracking
// Track watch progress
var lastWatchedPercentage = 0;
var lastWatchedPercentageRounded = 0;
AudioPlayer.prototype.trackWatchProgress = function(e) {
  var watchedPercentage = Math.round(this.player.currentTime / this.model.duration * 100);
  if (watchedPercentage > lastWatchedPercentage) {
    // Track all % changes
    trackEvent({
      category: EVENT_CATEGORY,
      action: "watched percentage",
      value: watchedPercentage
    });
  }
  lastWatchedPercentage = watchedPercentage;
  // Track 10% increments in a more obvious format
  var watchedPercentageRounded = Math.floor(watchedPercentage / 10) * 10;
  if (watchedPercentageRounded > lastWatchedPercentageRounded) {
    trackEvent({
      category: EVENT_CATEGORY,
      action: "watched " + watchedPercentageRounded + "%"
    });
  }
  lastWatchedPercentageRounded = watchedPercentageRounded;
};

// Export the creation function
module.exports = AudioPlayer;
