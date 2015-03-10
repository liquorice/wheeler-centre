var reactive = require("reactive");
// var Drag = require("mnmly/drag");
var hms = require("../hms");
var TouchPreview = require("../touch-preview");

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
    loadStarted: false,
    loadProgress: 0,
    playProgress: 0,
    trackPosition: 0,
    elementWidth: 0,
    isDragging: false
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
  // this.setupDragHandle();
  window.addEventListener("resize", this.onResize.bind(this), false);
  // this.handle.on("dragstart", this.onHandleDragStart.bind(this));
  // this.handle.on("drag", this.onHandleDrag.bind(this));
  // this.handle.on("dragend", this.onHandleDragEnd.bind(this));

  // Set up the player
  this.player = el.querySelector("audio");
  this.player.addEventListener("loadedmetadata", this.onMetadataLoaded.bind(this));
  this.player.addEventListener("timeupdate", this.onTimeUpdate.bind(this));
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
  this.handle = new Drag(this.handleEl, {
    axis: "x",
    range: {
      x: [0 + handleOffset, this.model.elementWidth - handleOffset]
    }
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
  this.view.set("currentTime", 0);
  this.view.set("playProgress", 0);
  this.view.set("trackPosition", 0);
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

// Export the creation function
module.exports = AudioPlayer;
