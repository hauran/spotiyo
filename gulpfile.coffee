gulp = require 'gulp'
less = require 'gulp-less'
minifyCSS = require 'gulp-minify-css'
browserify = require 'gulp-browserify'
rename = require 'gulp-rename'
shell = require 'gulp-shell'
replace = require 'gulp-replace'
concat = require 'gulp-concat'
express = require 'express'
util = require 'util'
refresh = require 'gulp-livereload'
lr = require 'tiny-lr'
server = lr()
handle = (stream)->
  stream.on 'error', ->
    util.log.apply this, arguments
    stream.end()


paths = 
  src:'./src/elements'
  less:'./src/less'
  dest:'build/'

gulp.task 'elements', ['elements-code', 'elements-style', 'elements-static']

gulp.task  'elements-code', ->
  gulp.src '**/*.coffee', {cwd: paths.src, read: false}
    .pipe handle browserify
      transform: ['coffeeify']
      debug: false
    .pipe rename extname: '.js'
    .pipe gulp.dest paths.dest

gulp.task  'elements-style', ->
  gulp.src '**/*.less', {cwd: paths.src}
    .pipe less()
    .pipe minifyCSS()
    .pipe gulp.dest paths.dest

gulp.task  'elements-static', ->
  gulp.src '**/*.html', {cwd: paths.src}
    .pipe gulp.dest paths.dest
  gulp.src '*.svg', {cwd: paths.src}
    .pipe gulp.dest paths.dest

gulp.task 'vulcanize', ['elements','style','refresh'], ->
  gulp.src '**/*.html', {cwd: paths.dest}
    .pipe shell([
      "vulcanize --inline --strip -o <%= file.path %> <%= file.path %>"
      ])

gulp.task 'style', ->
  gulp.src '**/*.less', {cwd: paths.less}
    .pipe less()
    .pipe minifyCSS()
    .pipe gulp.dest paths.dest

gulp.task 'refresh', ->
  refresh server

gulp.task 'build', ['vulcanize']

gulp.task 'watch', ->
  app = express()
  app.use(express.static(__dirname))
  app.listen(10000)

  watcher = gulp.watch ['src/**/*.*'], ['elements', 'style','refresh']
  watcher.on 'change', ->
    console.log 'rebuildling...'
