gulp = require 'gulp'
less = require 'gulp-less'
minifyCSS = require 'gulp-minify-css'
browserify = require 'gulp-browserify'
rename = require 'gulp-rename'
shell = require 'gulp-shell'
run = require 'gulp-run'
replace = require 'gulp-replace'
concat = require 'gulp-concat'
express = require 'express'
util = require 'util'
refresh = require 'gulp-livereload'
uglify = require 'gulp-uglify'
lr = require 'tiny-lr'
server = lr()
handle = (stream)->
  stream.on 'error', ->
    util.log.apply this, arguments
    stream.end()

gulp.task 'vendor', ->
  gulp.src ['node_modules/polymer/platform.js', 
    'bower_components/jquery/dist/jquery.min.js', 
    'bower_components/jquery-cookie/jquery.cookie.js',
    'bower_components/lodash/dist/lodash.min.js',
    'bower_components/moment/min/moment.min.js'
  ]
    .pipe(concat('vendor.js'))
    .pipe(uglify())
    .pipe(gulp.dest('./public/lib/'))

gulp.task 'elements', shell.task [
  'polymer-build src/elements/ build/'
]

gulp.task 'buildElements', ['elements'], ->
  gulp.src ['build/listener/*.html',
  'build/player/*.html',
  'build/playlist/*.html',
  'build/track/*.html',
  'build/tracks/*.html',
  'build/login/*.html'
  ]
    .pipe(concat('elements.html'))
    .pipe(gulp.dest('./public/elements/'))

gulp.task 'less', ->
  gulp.src('src/less/main.less')
    .pipe(less())
    .pipe(minifyCSS({
      keepSpecialComments: 0
    }))
    .pipe(gulp.dest('./public/style'))

gulp.task 'watch', ['buildElements','less'], ->
  gulp.watch './src/elements/**/*', ['buildElements']
  gulp.watch './src/less/**/*', ['less']





# gulp.task  'elements-code', ->
#   gulp.src '**/*.coffee', {cwd: paths.src, read: false}
#     .pipe handle browserify
#       transform: ['coffeeify']
#       debug: false
#     .pipe rename extname: '.js'
#     .pipe gulp.dest paths.dest

# gulp.task  'elements-style', ->
#   gulp.src '**/*.less', {cwd: paths.src}
#     .pipe less()
#     .pipe minifyCSS()
#     .pipe gulp.dest paths.dest

# gulp.task  'elements-static', ->
#   gulp.src '**/*.html', {cwd: paths.src}
#     .pipe gulp.dest paths.dest
#   gulp.src '*.svg', {cwd: paths.src}
#     .pipe gulp.dest paths.dest

# gulp.task 'vulcanize', ['elements','style','refresh'], ->
  # gulp.src '**/*.html', {cwd: paths.dest}
  #   .pipe shell([
  #     "vulcanize --inline --strip -o <%= file.path %> <%= file.path %>"
  #     ])

# gulp.task 'vulcanize', ['elements','style','refresh'], ->
#   return gulp.src(paths.build + 'index.html')
#     .pipe(vulcanize({
#       dest: paths.dest,
#       inline: false,
#       strip: true
#     }))
#     .pipe(gulp.dest(paths.build))


# gulp.task 'style', ->
#   gulp.src '**/*.less', {cwd: paths.less}
#     .pipe less()
#     .pipe minifyCSS()
#     .pipe gulp.dest paths.dest

# gulp.task 'refresh', ->
#   refresh server

# gulp.task 'build', ['vulcanize']

# gulp.task 'watch', ->
#   watcher = gulp.watch ['src/**/*.*'], ['build']
#   watcher.on 'change', ->
#     console.log 'rebuildling...'
