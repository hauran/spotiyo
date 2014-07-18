Polymer 'yo-listener',
  player:document.querySelector 'yo-player'
  clear: ->
    clearTimeout @clearTO
    @clearTO = setTimeout( =>
      @listening = false
      @cancel = false
      @tryAgain = false
      @command=''
    , 300)
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
    setTimeout =>
      @isListening()
      Android.speak()
    ,500

  cancelListening: ->
    @cancel = true
    setTimeout =>
      @listening = false
      @clearTO = undefined
    ,500

  refresh: ->
    window.location.reload()

  toggle: ->
    Android.togglePlay()

  next: ->
    Android.next()

  ready: () ->
    @command = ''
    @cancel = false
    @tryAgain = false
    @listening = false
    @clearTO = undefined
