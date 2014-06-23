(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
Polymer('yo-player', {
  play: function(toPlay) {
    var _this;
    _this = this;
    return $.post('/searchTrack', {
      toPlay: toPlay
    }, function(res) {
      var code;
      code = res.url.split('v=')[1].split('&')[0];
      _this.active = true;
      return _this.url = "https://www.youtube.com/embed/" + code + "?autoplay=1";
    });
  },
  ready: function() {
    this.title = '';
    this.active = false;
    this.loading = true;
    this.state = 0;
    this.items = [];
    return this.toPlay = _.debounce(this.getToPlay, 1000);
  },
  getTracks: function(id, href) {
    var _this;
    _this = this;
    setTimeout(function() {
      $(window).scrollTop(0);
      return _this.active = true;
    }, 350);
    return $.get("/playlists/" + id + "/tracks", {
      href: href
    }, function(res) {
      _this.loading = false;
      return _this.items = res.items;
    });
  },
  playFirst: function() {
    if (this.state === 1) {
      return;
    }
    this.state = 1;
    return this.play("" + this.items[0].track.artists[0].name + " - " + this.items[0].track.name);
  },
  close: function() {
    return this.active = false;
  }
});


},{}]},{},[1])