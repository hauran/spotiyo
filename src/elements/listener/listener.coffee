Polymer 'yo-listener',
  player:document.querySelector 'yo-player'
  clear: ->
    clearTimeout @clearTO
    _this = @
    @clearTO = setTimeout(->
      _this.listening = false
      _this.cancel = false
      _this.tryAgain = false
      _this.command=''
    , 3000)
    return

  processCmd: (command) ->
    @listening = true
    @command = command
    @clear()

  stopListening: ->
    @command=''
    @listening = false
    @cancel=false
    @tryAgain=false

  isListening: ->
    @command=''
    @listening = true
    @cancel=false
    @tryAgain=false

  tryAgainListening: ->
    @tryAgain = true
    _this = @
    setTimeout () ->
      _this.isListening()
      Android.speak()
    ,500

  cancelListening: ->
    @cancel = true
    _this = @
    setTimeout () ->
      _this.listening = false
      _this.clearTO = undefined
    ,500

  refresh: ->
    window.location.reload()

  ready: () -> 
    @command = ''
    @cancel = false
    @tryAgain = false
    @listening = false
    @clearTO = undefined
