Polymer 'yo-tracks',
  ready: ->
    @playlist = document.querySelector('yo-playlist')
    @player = document.querySelector('yo-player')
    @title = ''
    @active = false
    @loading = true
    @playing = null
    @items = []
    @isPlaylist = true

  play: (uri) ->
    @resetCurrentPlaying()
    setTimeout =>
      document.querySelector('yo-player').shadowRoot.querySelector('.controls').classList.add('showControls')
      @playlist.playerShow = true
    ,350
    try
      Android.play uri
    catch err
      console.log err

  queue: (uri) ->
    setTimeout =>
      document.querySelector('yo-player').shadowRoot.querySelector('.controls').classList.add('showControls')
      @playlist.playerShow = true
    ,350
    try
      console.log 'add', uri
      if @items.length is 0
        Android.play uri
      else
        Android.add uri
    catch err
      console.log err

  resetCurrentPlaying: ->
    currentPlaying = @currentPlaying()
    if currentPlaying
      currentPlaying.shadowRoot.querySelector('.item-name').classList.remove('selected')
      currentPlaying.removeAttribute 'playing'

  setPlaying: ->
    currentPlaying = @currentPlaying()
    if !currentPlaying
      try
        first = document.querySelector('yo-tracks').shadowRoot.querySelector('yo-track')
        first.setAttribute "playing", "true"
        first.shadowRoot.querySelector('.item-name').classList.add 'selected'
        @player.track first.name, first.artist
      catch err

  skipNext: ->
    currentTrack = @currentPlaying()
    @resetCurrentPlaying()
    next = document.querySelector('yo-tracks').shadowRoot.querySelectorAll('yo-track')[currentTrack.number+1]
    next.setAttribute "playing", "true"
    next.shadowRoot.querySelector('.item-name').classList.add 'selected'
    @player.track next.name, next.artist

  currentPlaying: ->
    currentPlaying = document.querySelector('yo-tracks').shadowRoot.querySelector('[playing=true]')
    currentPlaying

  getTracks: (id,href,uri) ->
    @player.pause()
    @resetCurrentPlaying()
    @items = []
    @loading = true
    @active = true
    $(window).scrollTop(0)

    $.get "/playlists/#{id}/tracks", {href:href}, (res) =>
      @loading = false
      @items = res.items
      @play uri
      @player.play()

  addTrack: (name, artist, uri) ->
    @loading = false
    number = @items.length
    item =
      number: number
      track: {
        artists:[
          {name:artist}
        ]
        name:name
        uri:uri
        album: {
          images:[]
        }
      }
    @items.push item
    @isPlaylist = false
    setTimeout =>
      @setPlaying()
    ,500

  close:() ->
    @active = false
    @playlist.open()

  open: ->
    @active = true
    if @title is ''
      @title = "Spotiyo"
