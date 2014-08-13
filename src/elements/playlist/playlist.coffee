Polymer 'yo-playlist',
  ready: ->
    @active = false
    @playlists = []
    @playerShow = false
    @selected = null
    @tracks = document.querySelector('yo-tracks')
    @home = document.querySelector('yo-login')

  getPlayLists: ->
    $.get '/playlists', (res) =>
      # @playlists = res.items
      @active = true
      setTimeout =>
        @home.loggedIn = true
      ,500
  #
  # selectPlaylist: (evt) ->
  #   $pl = $(evt.toElement)
  #   id = $pl.attr 'id'
  #   @selected = id
  #   href = $pl.attr 'tracks-href'
  #   uri = $pl.attr 'uri'
  #   @active = false
  #   @tracks.title = $pl.html()
  #   @tracks.getTracks id,href,uri

  makeMix: (evt) ->
    @makeMixClick = true
    setTimeout =>
      window.location.href="/makeMix"
    ,300

  open: ->
    @active = true

  close:() ->
    @active = false
