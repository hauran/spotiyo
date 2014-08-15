Polymer 'yo-playlist',
  ready: ->
    @active = false
    @playlists = []
    @playerShow = false
    @selected = null
    @tracks = document.querySelector('yo-tracks')
    @home = document.querySelector('yo-login')

  getPlayLists: ->
    $.get '/spotify/playlists', (res) =>
    # $.get '/playlists', (res) =>
      # @playlists = res.items
    @playlists = [
      {
        name:'Very Labor Steam Remain Better'
        date:'August 12 2014'
        tracks: 12
        starred:false
      }
      {
        name:'Trick Sitting Dream Tobacco'
        date:'August 11 2014'
        tracks: 11
        starred:true
      }
      {
        name: 'Short No Second'
        date:'August 10 2014'
        tracks: 9
        starred:true
      }
      {
        name:'Darkness During Unusual Death Cutting'
        date:'August 9 2014'
        tracks: 14
        starred:false
      }
      {
        name:'Doing Rhythm Tube'
        date:'August 8 2014'
        tracks: 13
        starred:false
      }
      {
        name:'Upper Four Tropical Chose'
        date:'August 7 2014'
        tracks: 8
        starred:true
      }
      {
        name:'Amount Herself Wool'
        date:'August 6 2014'
        tracks: 10
        starred:true
      }
    ]
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
