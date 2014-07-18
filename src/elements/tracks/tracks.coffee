Polymer 'yo-tracks',
  ready: ->
    @playlist = document.querySelector('yo-playlist')
    @player = document.querySelector('yo-player')
    @title = ''
    @active = false
    @loading = true
    @playing = null
    @items = []

  play: (uri) ->
    @resetCurrentPlaying()
    setTimeout ->
      document.querySelector('yo-player').shadowRoot.querySelector('.controls').classList.add('showControls')
    ,350
    try
      Android.play uri
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
      first = document.querySelector('yo-tracks').shadowRoot.querySelector('yo-track')
      first.setAttribute "playing", "true"
      first.shadowRoot.querySelector('.item-name').classList.add 'selected'
      @player.track first.name, first.artist

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
    _this = @
    @items = []
    @loading = true
    @active = true
    $(window).scrollTop(0)

    $.get "/playlists/#{id}/tracks", {href:href}, (res) ->
      _this.loading = false
      _this.items = res.items
      _this.play uri

  close:() ->
    @active = false
    _this = @
    _this.playlist.open()
