Polymer 'yo-player',
  ready: ->
    # @tracks = document.querySelector('yo-tracks')
    @state = 'play'

  play: ->
    @state = 'play'
    try
      Android.playerPlay()
    catch err
      console.log err

  pause: ->
    @state = 'pause'
    try
      Android.playerPause()
    catch err
      console.log err

  next: ->
    @state = 'play'
    # @tracks.skipNext()
    # try
    #   Android.playerNext()
    # catch err
    #   console.log err

  track: (name, artist) ->
    @name = name
    @artist = artist
