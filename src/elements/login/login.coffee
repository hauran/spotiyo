Polymer 'yo-login',
  loginClick: ->
    @active = true
    @login = 'hold on... I\'m making music'

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
    @playlist = document.querySelector('yo-playlist')
    if $.cookie('userId')
      @active = true
      @login = 'hold on... I\'m making music'
      @playlist.getPlayLists()
