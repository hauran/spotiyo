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
      if(@tracks.isPlaylist)
        if number > current
          Android.skipForward skip
        else
          Android.skipBack skip
      else
        Android.play @uri
        @queueNext()
    catch err
      console.log err

  queueNext: ->
    found = false
    allTracks = document.querySelector('yo-tracks').shadowRoot.querySelectorAll('yo-track')
    i = 0

    while i < allTracks.length
      @tracks.queue allTracks[i].uri if found
      found = true if allTracks[i].uri is @uri
      i++
