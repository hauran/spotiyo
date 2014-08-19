Polymer 'yo-login',
  loginClick: ->
    @active = true
    @login = 'hold on'

  showPlaylist: ->
    @activePlaylists = true
    setTimeout =>
      @playlist.open()
    ,350
    setTimeout =>
      @activePlaylists = false
    , 1000

  ready: ->
    @url = ''
    @active = false
    @activePlaylists = false
    @login = 'log in'
    @loggedIn = false
    @playlists = document.querySelector('yo-playlists')
    if $.cookie('userId')
      if $.cookie('userId') is 'undefined'
        $.removeCookie('access_token')
        $.removeCookie('expires_on')
        $.removeCookie('refresh_token')
        $.removeCookie('userId')
      else
        @active = true
        @login = 'hold on'
        @playlists.getPlayLists()
