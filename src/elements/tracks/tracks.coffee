Polymer 'yo-tracks',
  ready: ->
    @playlists = document.querySelector('yo-playlists')
    @player = document.querySelector('yo-player')
    @title = ''
    @active = false
    @loading = true
    @playing = null
    @items = []
    @isPlaylist = true
    @currentTrackDuration = 0

  play: (uri) ->
    @resetCurrentPlaying()
    # setTimeout =>
    #   document.querySelector('yo-player').shadowRoot.querySelector('.controls').classList.add('showControls')
    #   @playlists.playerShow = true
    # ,350
    try
      Android.play uri
    catch err
      console.log err

  resetCurrentPlaying: ->
    currentPlaying = @currentPlaying()
    if currentPlaying
      currentPlaying.shadowRoot.querySelector('.item-name').classList.remove('selected')
      currentPlaying.removeAttribute 'playing'
  #
  # skipNext: ->
  #   currentTrack = @currentPlaying()
  #   @resetCurrentPlaying()
  #   next = document.querySelector('yo-tracks').shadowRoot.querySelectorAll('yo-track')[currentTrack.number+1]
  #   next.setAttribute "playing", "true"
  #   next.shadowRoot.querySelector('.item-name').classList.add 'selected'
  #   @player.track next.name, next.artist

  skipNext: ->
    @currentTrack++
    @playCurrentTrack()

  playTrackNumber: (number) ->
    @currentTrack = number
    @playCurrentTrack()

  currentPlaying: ->
    @shadowRoot.querySelector('[playing=true]')

  makeMix: (callback)->
    @currentTrack = 0
    @items = []
    @loading = true
    @active = true
    $(window).scrollTop(0)
    $.get "/makeMix", {}, (res) =>
      @loading = false
      @items = res.tracks
      @title = res.title
      @playCurrentTrack()
      @player.play()
      callback(res)

  playCurrentTrack: ->
    @resetCurrentPlaying()
    @currentTrackDuration = @items[@currentTrack].track.duration_ms - 3500
    @player.track @items[@currentTrack].track.name, @items[@currentTrack].track.artists[0].name
    @play @items[@currentTrack].track.uri
    @setCurrentTrackPlaying()
    setTimeout =>
      @checkTrackEnded()
    , 1000

  setCurrentTrackPlaying: ->
    current = @shadowRoot.querySelectorAll('yo-track')[@currentTrack]
    return if !current
    current.setAttribute "playing", "true"
    current.shadowRoot.querySelector('.item-name').classList.add 'selected'

  checkTrackEnded: ->
    try
      currentPosition = Android.currentPosition()
      # console.log currentPosition, @currentTrackDuration, currentPosition >= @currentTrackDuration
      if currentPosition >= @currentTrackDuration
        console.log 'NEXT NEXT'
        @playCurrentTrack(++@currentTrack)
      else
        setTimeout =>
           @checkTrackEnded()
        , 500
    catch err
      console.log err


  close:() ->
    @active = false
    @playlists.open()

  open: ->
    @active = true
    if @title is ''
      @title = "Spotiyo"
