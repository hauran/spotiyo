Polymer 'yo-login',
  loginClick: ->
    @active = true
    @login = 'hold on'

  showPlaylist: ->
    _this = @
    @activePlaylists = true
    _this.playlist.open()
    setTimeout ->
      _this.activePlaylists = false
    , 1000


  ready: ->
    @url = ''
    @active = false
    @activePlaylists = false
    @login = 'log in'
    @loggedIn = false
    @playlist = document.querySelector('yo-playlist')
    _this = @

    if $.cookie('userId')
      @active = true
      @login = 'hold on'
      @playlist.getPlayLists()
        