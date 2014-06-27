Polymer 'yo-listener',
  player:document.querySelector 'yo-player'
  clear: ->
    clearTimeout @clearTO
    _this = @
    @clearTO = setTimeout(->
      _this.listening = false
      _this.cancel = false
      _this.command=''
    , 3000)
    return

  processCmd: (command) ->
    @listening = true
    @command = command
    @clear()

  isListening: ->
    @command=''
    @listening = true
    @cancel=false

  cancelClick: ->
    @cancel = true
    _this = @
    setTimeout () ->
      _this.isListening()
      Android.speak()
    ,500

  ready: () -> 
    @command = ''
    @cancel = false
    @listening = false
    @clearTO = undefined
