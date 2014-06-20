express = require('express')
os = require('os')
http = require('http')
path = require('path')
fs = require('fs')
_ = require('lodash')
cors = require('cors')

app = express()

app.set('root', process.cwd())

app.configure 'development', ->
	app.set('port', process.argv[2] || 10000)

app.configure 'production', ->
	app.set('port', process.env.PORT || 3000)

app.configure () ->
	# app.use express.favicon('public/img/favicon.png')
	app.use express.bodyParser()
	app.use express.methodOverride()
	app.use express.cookieParser('cookies!')

	app.use '/node_modules', express.static(path.join(app.get('root'), 'node_modules')) 
	app.use '/bower_components', express.static(path.join(app.get('root'), 'bower_components')) 
	app.use '/build', express.static(path.join(app.get('root'), 'build'))

	app.use cors()
	app.use app.router

app.set 'views', __dirname
app.engine 'html', require('ejs').renderFile
app.enable 'trust proxy'

# controllerFiles = fs.readdirSync('controllers')
# controllerFiles.forEach (controllerFile) ->
# 	if controllerFile.indexOf('.coffee') is -1
# 		return
# 	else
# 		controllerFile = controllerFile.replace '.coffee', ''
# 		controller = require './controllers/' + controllerFile
# 		if(controller.setup)
# 			controller.setup app

app.get '/', (req, res) ->
	res.render 'index.html', {}

server = http.createServer(app).listen app.get('port'), '0.0.0.0', () ->
	console.log 'yoplay server listening on port ' + app.get('port')
