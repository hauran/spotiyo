(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
Polymer('yo-player', {
  play: function(rtsp) {
    return Android.loadVideo(rtsp);
  },
  ready: function() {
    this.playlist = document.querySelector('yo-playlist');
    this.title = '';
    this.active = false;
    this.noHeight = true;
    this.loading = true;
    return this.items = [];
  },
  loadPlaylist: function() {
    var rtsps;
    rtsps = [];
    _.each(this.items, function(item) {
      return rtsps.push(item.rtsp);
    });
    return Android.loadPlaylist(rtsps.join());
  },
  getTracks: function(id, href) {
    var _this;
    _this = this;
    this.noHeight = false;
    this.items = [];
    this.loading = true;
    setTimeout(function() {
      $(window).scrollTop(0);
      return _this.active = true;
    }, 350);
    return $.get("/playlists/" + id + "/tracks", {
      href: href
    }, function(res) {
      _this.loading = false;
      _this.items = res.items;
      return _this.loadPlaylist();
    });
  },
  close: function() {
    var _this;
    this.active = false;
    Android.hideVideo;
    _this = this;
    return _this.playlist.open();
  }
});


},{}]},{},[1])