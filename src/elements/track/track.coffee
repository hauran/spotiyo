Polymer 'yo-track',
  artist:''
  name:''
  imgsrc:''
  uri:''
  ready: ->
    @tracks = document.querySelector('yo-tracks')
    @player = document.querySelector('yo-player')

  playTrack: ->
    current = @tracks.currentPlaying().number
    number = @number
    skip = Math.abs(number - current)
    @player.track @name, @artist
    try
        if number > current
          Android.skipForward skip
        else
          Android.skipBack skip
    catch err
      console.log err
