browserify  = require 'gulp-browserify'
coffee      = require 'gulp-coffee'
coffeeify   = require 'coffeeify'
concat      = require 'gulp-concat'
connect     = require 'connect'
connectjs   = require 'connect-livereload'
gulp        = require 'gulp'
gutil       = require 'gulp-util'
less        = require 'gulp-less'
livereload  = require 'gulp-livereload'
mocha       = require 'gulp-mocha'
serve       = require 'serve-static'

project =
  dest:       './build/'
  src:        './app/**/*.coffee'
  static:     './static/**'
  fonts:      './style/font/**'
  fontsDest:  './build/font'
  style:      './style/**'

gulp.task 'default', ['build']
gulp.task 'build', ['src', 'manifest', 'index', 'static', 'style', 'fonts']
gulp.task 'watch:serve', ['watch', 'serve']

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

gulp.task 'serve', ['build'], ->
  lr  = livereload()
  app = connect()
  app
    .use(connectjs())
    .use(serve(project.dest))
  app.listen(process.env['PORT'] or 4001)
  livereload.listen()
  gulp.watch("#{project.dest}/**").on 'change', (file) ->
    lr.changed(file.path)

gulp.task 'watch', ->
  gulp.watch(project.src, ['src'])
  gulp.watch(project.style, ['style'])
  gulp.watch(project.static, ['static'])
