Polymer 'yo-track',
  artist:''
  name:''
  imgsrc:''
  uri:''
  ready: ->
    @tracks = document.querySelector('yo-tracks')
    @player = document.querySelector('yo-player')

  playTrack: ->
    try
      Android.play @uri
    catch err
      console.log err
    # current = @tracks.currentPlaying().number
    # number = @number
    # skip = Math.abs(number - current)
    # @player.track @name, @artist
    #
    # try
    #   if(@tracks.isPlaylist)
    #     if number > current
    #       Android.skipForward skip
    #     else
    #       Android.skipBack skip
    #   else
    #     Android.play @uri
    # catch err
    #   console.log err
