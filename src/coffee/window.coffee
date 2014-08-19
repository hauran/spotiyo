xPoint = (x) ->
  @updated = false
  @x = @_prev = @_origin = x
  @_timeStamp = (new Date()).getTime()
  return

xPoint:: =
  TIMER_RESET_THRESHOLD: -5 # px
  VELOCITY_THRESHOLD: -0.2 # px/ms
  distance: ->
    # distance between touch start and current point
    @x - @_origin

  update: (x) ->
    # reset time stamp at move stop
    if x - @x > @TIMER_RESET_THRESHOLD
      @_timeStamp = (new Date()).getTime()
      @_prev = @x
    @x = x
    @updated = true
    return

  isFlick: ->
    dt = (new Date()).getTime() - @_timeStamp
    dx = @x - @_prev
    (dx / dt) < @VELOCITY_THRESHOLD

  isFlickDown: ->
    dt = (new Date()).getTime() - @_timeStamp
    dx = @_prev - @x
    (dx / dt) < @VELOCITY_THRESHOLD
