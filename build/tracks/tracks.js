(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
Polymer('yo-tracks', {
  play: function(rtsp) {
    return Android.loadVideo(rtsp);
  },
  ready: function() {
    this.playlist = document.querySelector('yo-playlist');
    this.title = '';
    this.active = false;
    this.noHeight = true;
    this.loading = true;
    this.playing = null;
    return this.items = [];
  },
  play: function(uri) {
    var err;
    try {
      return Android.play(uri);
    } catch (_error) {
      err = _error;
      return console.log(err);
    }
  },
  getTracks: function(id, href, uri) {
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
      return _this.play(uri);
    });
  },
  close: function() {
    var _this;
    this.active = false;
    _this = this;
    _this.playlist.open();
    return setTimeout(function() {
      return _this.noHeight = true;
    }, 450);
  }
});


},{}]},{},[1])