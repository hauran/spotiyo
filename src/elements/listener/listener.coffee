Polymer 'yo-listener',
  clear: ->
    clearTimeout @clearTO
    _this = @
    @clearTO = setTimeout(->
      _this.listening = false
      return
    , 3000)
    return

  cleanCommand: (cmd, delimit) ->
    cmd.split(delimit)[1]

  processCmd: ->
    cmd = @transcript.trim().toLowerCase()
    if (@listening and cmd.indexOf("play") is 0) or cmd.indexOf("yo play") is 0
      @listening = true
      toPlay = @cleanCommand cmd, 'play'
      @command = "playing #{toPlay}"
      debugger;
      player = document.querySelector 'yo-player'
      player.toPlay toPlay

      @clear()
    else if cmd.indexOf("yo") is 0 or cmd.indexOf("Yelp") is 0
      @listening = true
      @command = "what up?"
      @clear()
    return

  listen: ->
    unless "webkitSpeechRecognition" of window
      alert "Web speech API is not supported in this browser"
    else
      recognizer = new webkitSpeechRecognition()
      recognizer.continuous = true
      recognizer.interimResults = true
      recognizer.lang = [
        "English"
        [
          "en-US"
          "United States"
        ]
      ]
      _this = @
      recognizer.onresult = (e) ->
        _this.transcript = ""
        if e.results.length
          i = event.resultIndex
          while i < event.results.length
            _this.transcript = event.results[i][0].transcript
            _this.processCmd()
            i++
        return

      recognizer.start()

  ready: () -> 
    @transcript = ""
    @clearTO = undefined
    @listening = false
    @listen()