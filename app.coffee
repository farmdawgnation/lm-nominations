express = require 'express'
require './model/Nomination'
routes = require './routes'
jqtpl = require 'jqtpl'
mongoose = require 'mongoose'
MongoStore = require('connect-mongo')

app = module.exports = express.createServer()

# Configuration
app.configure () ->
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'html'
  app.register '.html', jqtpl.express
  app.use express.bodyParser()
  app.use express.cookieParser()
  app.use express.methodOverride()
  mongoose.connect "mongodb://localhost/leadership-macon-nominations"
  app.use express.session({ secret: "wakkwakkawakka123", store: new MongoStore({ db: "leadership-macon-nominations" }) })
  app.use app.router
  app.use express.static(__dirname + '/public')

app.configure 'development', () ->
  app.use express.errorHandler, { dumpExceptions: true, showStack: true }

app.configure 'production', () ->
  app.use express.errorHandler

# Routes
app.get '/', routes.index
app.post '/submit', routes.submit

# Ensure the AWS keys are specified
if ! process.env.AWS_ACCESSKEY || process.env.AWS_ACCESSKEY == "ACCESSKEYGOESHERE" || ! process.env.AWS_SECRETKEY || process.env.AWS_SECRETKEY == "SECRETKEYGOESHERE"
  console.error "AWS keys have not been properly defined. Please define the keys in run.sh and restart."
  process.exit(1)

app.listen process.env.PORT || 3000
console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env
