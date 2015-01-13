browserify  = require 'gulp-browserify'
concat      = require 'gulp-concat'
gulp        = require 'gulp'

project =
  dest:   './build/'
  src:    './app/**/*.coffee'
  static: './static/**'
  fonts: './style/font/**'
  fontsDest:   './build/font'
  style:  './style/**'

gulp.task 'default', ['build']
gulp.task 'build', ['src', 'manifest', 'index', 'static', 'style', 'fonts']

gulp.task 'src', ->
  gulp.src('./app/index.coffee',  read: false)
    .pipe(browserify({
      transform:  ['coffeeify']
      extensions: ['.coffee']
    }))
    .pipe(concat('app.js'))
    .pipe(gulp.dest(project.dest))

gulp.task 'index', ->
  gulp.src('./app/index.html')
    .pipe(gulp.dest(project.dest))

gulp.task 'static', ->
  gulp.src(project.static)
    .pipe(gulp.dest(project.dest))

gulp.task 'fonts', ->
  gulp.src(project.fonts)
    .pipe(gulp.dest(project.fontsDest))

gulp.task 'style', ->
  gulp.src(project.style)
    .pipe(concat('app.css'))
    .pipe(gulp.dest(project.dest))

gulp.task 'manifest', ->
  gulp.src('./manifest.json')
    .pipe(gulp.dest(project.dest))
