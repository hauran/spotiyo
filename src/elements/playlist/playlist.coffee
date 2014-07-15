Polymer 'yo-playlist',
  ready: ->
    @active = false
    @playlists = []
    @selected = null
    @tracks = document.querySelector('yo-tracks')
    @home = document.querySelector('yo-login')

  getPlayLists: ->
    _this = @
    $.get '/playlists', (res) ->
      _this.playlists = res.items
      _this.active = true
      setTimeout ->
        _this.home.loggedIn = true
      ,500

  selectPlaylist: (evt) ->
    _this = @
    $pl = $(evt.toElement)
    id = $pl.attr 'id'
    @selected = id
    href = $pl.attr 'tracks-href'
    uri = $pl.attr 'uri'
    @active = false
    @tracks.title = $pl.html()
    @tracks.getTracks id,href,uri

  open: ->
    @active = true

  close:() ->
    @active = false
