Polymer 'yo-player',
  audio:null
  getToPlay: (toPlay) ->
    console.log('toPlay', toPlay)
    _this = @
    req = new XMLHttpRequest()
    req.open 'GET', 'https://api.spotify.com/v1/search?type=track&q=' + encodeURIComponent(toPlay), true
    req.onreadystatechange = ->
      if (req.readyState == 4 && req.status == 200)
        data = JSON.parse(req.responseText)
        _this.stop()
        _this.audio = new Audio(data.tracks.items[0].preview_url)
        _this.audio.play()
        
    req.send(null);

  stop: ->
    if @audio
      @audio.pause()

  ready: ->
    @toPlay = _.debounce(@getToPlay,1000)
  