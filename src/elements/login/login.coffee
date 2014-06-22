url = require "url"

Polymer 'yo-login',
  loginClick: ->
    @active = true
    @login = 'hold on'

  ready: ->
    @url = ''
    @active = false
    @login = 'log in'
    @player = document.querySelector('yo-player')
    _this = @

    if $.cookie('userId')
      @active = true
      @login = 'hold on'

      $.get '/playlists', (res) ->
        _this.player.playlists = res.items
        _this.player.active = true
    