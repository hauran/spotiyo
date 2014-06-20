Polymer 'yo-player',
  getToPlay: (toPlay) ->
    console.log(toPlay)
  ready: ->
    @toPlay = _.debounce(@getToPlay,500)
  