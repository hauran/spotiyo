(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
Polymer('yo-playlist', {
  ready: function() {
    this.active = false;
    this.noHeight = false;
    this.playlists = [];
    this.selected = null;
    this.player = document.querySelector('yo-player');
    return this.home = document.querySelector('yo-login');
  },
  getPlayLists: function() {
    var _this;
    _this = this;
    return $.get('/playlists', function(res) {
      _this.playlists = res.items;
      _this.noHeight = false;
      _this.active = true;
      return setTimeout(function() {
        return _this.home.loggedIn = true;
      }, 500);
    });
  },
  selectPlaylist: function(evt) {
    var $pl, href, id, uri, _this;
    _this = this;
    $pl = $(evt.toElement);
    id = $pl.attr('id');
    this.selected = id;
    href = $pl.attr('tracks-href');
    uri = $pl.attr('uri');
    this.active = false;
    this.player.title = $pl.html();
    this.player.getTracks(id, href, uri);
    return setTimeout(function() {
      return _this.noHeight = true;
    }, 450);
  },
  open: function() {
    var _this;
    _this = this;
    this.noHeight = false;
    return setTimeout(function() {
      return _this.active = true;
    }, 350);
  },
  close: function() {
    return this.active = false;
  }
});


},{}]},{},[1])