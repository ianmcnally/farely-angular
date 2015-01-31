gulp = require 'gulp'
autoprefixer = require 'gulp-autoprefixer'
bower = require 'gulp-bower'
clean = require 'gulp-clean'
coffee = require 'gulp-coffee'
concat = require 'gulp-concat'
connect = require 'gulp-connect'
htmlmin = require 'gulp-htmlmin'
karma = require('karma').server
mainBowerFiles = require 'main-bower-files'
rename = require 'gulp-rename'
replace = require 'gulp-replace'
sass = require 'gulp-sass'
templates = require 'gulp-ng-templates'
uglify = require 'gulp-uglify'
util = require 'gulp-util'
vendor = require 'gulp-concat-vendor'

gulp.task 'bower:install', ->
  bower()

gulp.task 'bower', ['bower:install'], ->
  # get minified js components and concat
  gulp.src mainBowerFiles()
    .pipe vendor 'vendor.js'
    .pipe uglify
      beautify : false
      compress : true
      mangle : false
    .pipe gulp.dest 'public/javascript'
  # copy css components
  gulp.src 'bower_components/*/*.css'
    .pipe gulp.dest 'public/stylesheets/'

gulp.task 'coffee', ->
  gulp.src 'src/**/*.coffee'
    .pipe concat 'main.coffee'
    .pipe coffee().on 'error', util.log
    .pipe clean()
    .pipe gulp.dest 'public/javascript'

gulp.task 'compile', ['bower', 'copy:icons', 'copy:layout', 'copy:manifest', 'templates', 'coffee', 'style'], ->

gulp.task 'compile:prod', ['compile'], ->
  gulp.src 'public/javascript/main.js'
    .pipe uglify
      beautify : false
      compress : true
      mangle : true
    .pipe gulp.dest 'public/javascript'

gulp.task 'connect', ->
  connect.server
    root : 'public'
    livereload : true

gulp.task 'copy:icons', ->
  gulp.src 'src/icons/*'
    .pipe gulp.dest 'public/'

gulp.task 'copy:layout', ->
  gulp.src 'src/layout.html'
    .pipe rename 'index.html'
    .pipe htmlmin collapseWhitespace : true
    .pipe gulp.dest 'public/'

gulp.task 'copy:manifest', ->
  gulp.src 'src/cache.manifest'
    .pipe replace /:revision-date/, new Date().getTime()
    .pipe gulp.dest 'public/'

gulp.task 'default', ['compile', 'connect', 'watch'], ->

gulp.task 'style', ->
  gulp.src 'src/main.scss'
    .pipe sass
      errLogToConsole : true
    .pipe autoprefixer
      browsers : ['last 2 versions']
      cascade : false
    .pipe gulp.dest 'public/stylesheets/'

gulp.task 'templates', ->
  gulp.src 'src/**/*.html'
    .pipe htmlmin collapseWhitespace : true
    .pipe templates
      filename : 'templates.js'
      module : 'app.templates'
    .pipe gulp.dest 'public/javascript'

gulp.task 'test', (done) ->
  karma.start
    configFile : "#{__dirname}/karma.conf.coffee"
  , done

gulp.task 'test:browser', (done) ->
  karma.start
    configFile : "#{__dirname}/karma.conf.coffee"
    browsers : ['Chrome']
    singleRun : false
  , done

gulp.task 'watch', ->
  gulp.watch ['src/**/*.html'], ['templates', 'copy:layout', 'copy:manifest']
  gulp.watch ['src/**/*.coffee'], ['coffee', 'copy:manifest']
  gulp.watch ['src/**/*.scss'], ['style', 'copy:manifest']