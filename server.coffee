express = require('express')
os = require('os')
http = require('http')
path = require('path')
fs = require('fs')
_ = require('lodash')
cors = require('cors')
bodyParser = require('body-parser')
cookieParser = require('cookie-parser')

auth = require('./middleware/auth')

app = express()

app.set('root', process.cwd())
app.set('port', process.env.PORT || 8080)

app.use bodyParser.urlencoded()
app.use bodyParser.json()

# app.use express.favicon('public/img/favicon.png')

app.use express.static(__dirname + "/public")

app.use '/img', express.static(path.join(app.get('root'), 'img')) 
app.use '/fonts', express.static(path.join(app.get('root'), 'fonts'))
app.use '/node_modules', express.static(path.join(app.get('root'), 'node_modules')) 
app.use '/bower_components', express.static(path.join(app.get('root'), 'bower_components')) 
app.use '/build', express.static(path.join(app.get('root'), 'build'))

app.use cookieParser()
app.use auth()
app.use cors()

# app.use app.router

app.engine 'html', require('ejs').renderFile
app.enable 'trust proxy'

controllerFiles = fs.readdirSync('controllers')
controllerFiles.forEach (controllerFile) ->
	if controllerFile.indexOf('.coffee') is -1
		return
	else
		controllerFile = controllerFile.replace '.coffee', ''
		controller = require './controllers/' + controllerFile
		if(controller.setup)
			controller.setup app

app.get '/', (req, res) ->
	res.render 'index.html', {}

server = http.createServer(app).listen app.get('port'), '0.0.0.0', () ->
	console.log 'yoplay server listening on port ' + app.get('port')
