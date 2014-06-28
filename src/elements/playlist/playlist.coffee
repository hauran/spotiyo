Polymer 'yo-playlist',
  ready: ->
    @active = false
    @noHeight = false
    @playlists = []
    @player = document.querySelector('yo-player')
    @home = document.querySelector('yo-login')

  getPlayLists: ->
    _this = @
    $.get '/playlists', (res) ->
      _this.playlists = res.items
      _this.noHeight = false
      _this.active = true
      setTimeout ->
        _this.home.loggedIn = true
      ,500
      
  selectPlaylist: (evt) ->
    _this = @
    $pl = $(evt.toElement)
    id = $pl.attr 'id'
    href = $pl.attr 'tracks-href'
    @active = false
    @player.title = $pl.html()
    @player.getTracks id,href
    setTimeout ->
      _this.noHeight = true
    ,450

  open: ->
    _this = @
    @noHeight = false
    setTimeout ->
      _this.active = true
    ,350

  close:() ->
    @active = false
  