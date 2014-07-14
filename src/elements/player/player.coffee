Polymer 'yo-player',
  ready: ->
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
    try
      Android.playerNext()
    catch err
      console.log err

