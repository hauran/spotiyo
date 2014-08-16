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
        img:'https://i.scdn.co/image/9c96397a44a01c2e1c2d6d136f859f5270e1ddfc'
      }
      {
        name:'Trick Sitting Dream Tobacco'
        date:'August 11 2014'
        tracks: 11
        starred:true
        img:'https://i.scdn.co/image/00a21204f96a62839b0f2adc338533bd35429b7a'
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
      {
        name:'Thrown Appropriate Divide'
        date:'August 5 2014'
        tracks: 11
        starred:false
      }
    ]

    @active = true
    setTimeout =>
      @home.loggedIn = true
      @home.active = false
    ,500

  selectPlaylist: (evt) ->
    # $pl = $(evt.toElement)
    # id = $pl.attr 'id'
    # @selected = id
    # href = $pl.attr 'tracks-href'
    # uri = $pl.attr 'uri'
    @active = false
    # @tracks.title = $pl.html()
    # @tracks.getTracks id,href,uri
    @tracks.makeMix()

  star: (evt) ->
    $pl = $(evt.toElement)
    $pl.toggleClass('fa-star').toggleClass('fa-star-o')
    evt.stopPropagation()

  open: ->
    @active = true

  close:() ->
    @active = false
