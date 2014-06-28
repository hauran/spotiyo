(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
Polymer('yo-login', {
  loginClick: function() {
    this.active = true;
    return this.login = 'hold on';
  },
  showPlaylist: function() {
    var _this;
    _this = this;
    this.activePlaylists = true;
    setTimeout(function() {
      return _this.playlist.open();
    }, 250);
    return setTimeout(function() {
      return _this.activePlaylists = false;
    }, 1000);
  },
  ready: function() {
    var _this;
    this.url = '';
    this.active = false;
    this.activePlaylists = false;
    this.login = 'log in';
    this.loggedIn = false;
    this.playlist = document.querySelector('yo-playlist');
    _this = this;
    if ($.cookie('userId')) {
      this.active = true;
      this.login = 'hold on';
      return this.playlist.getPlayLists();
    }
  }
});


},{}]},{},[1])