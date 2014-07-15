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
