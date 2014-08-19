<script>var xPoint;

xPoint = function(x) {
  this.updated = false;
  this.x = this._prev = this._origin = x;
  this._timeStamp = (new Date()).getTime();
};

xPoint.prototype = {
  TIMER_RESET_THRESHOLD: -5,
  VELOCITY_THRESHOLD: -0.2,
  distance: function() {
    return this.x - this._origin;
  },
  update: function(x) {
    if (x - this.x > this.TIMER_RESET_THRESHOLD) {
      this._timeStamp = (new Date()).getTime();
      this._prev = this.x;
    }
    this.x = x;
    this.updated = true;
  },
  isFlick: function() {
    var dt, dx;
    dt = (new Date()).getTime() - this._timeStamp;
    dx = this.x - this._prev;
    return (dx / dt) < this.VELOCITY_THRESHOLD;
  },
  isFlickDown: function() {
    var dt, dx;
    dt = (new Date()).getTime() - this._timeStamp;
    dx = this._prev - this.x;
    return (dx / dt) < this.VELOCITY_THRESHOLD;
  }
};
</script>