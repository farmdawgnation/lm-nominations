
/**
 * Module dependencies.
 */

var express = require('express')
  , csv = require('express-csv')
  , routes = require('./routes')
  , http = require('http')
  , path = require('path')
  , bcrypt = require('bcrypt')
  , errorhandler = require('errorhandler')
  , morgan = require('morgan')
  , basicAuth = require('basic-auth-connect')
  , bodyParser = require('body-parser');

var app = module.exports = express();

// all environments
app.set('port', process.env.PORT || 3000);
app.set('views', __dirname + '/views');
app.set('view engine', 'jade');
app.set('export authenticator', function(req, res, callback) { callback(); });

app.use(bodyParser.urlencoded({ extended: true }));
app.use(require('stylus').middleware(__dirname + '/public'));
app.use(express.static(path.join(__dirname, 'public')));

// development only
if ('development' == app.get('env')) {
  app.use(errorhandler());
  app.use(morgan('dev'));
}

// production only
if ('production' == app.get('env')) {
  app.use(morgan('dev'));

  app.set('export authenticator', basicAuth(function(user, pass, callback) {
    var authSuccess =
      (user == process.env.EXPORT_USERNAME && bcrypt.compareSync(pass, process.env.EXPORT_PASSWORD));

    if (authSuccess)
      callback(null, true);
    else
      callback("Invalid username or password.", false);
  }));
}

// Build routes.
routes.build(app);

http.createServer(app).listen(app.get('port'), function(){
  console.log('Express server listening on port ' + app.get('port'));
});
