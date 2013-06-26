
/**
 * Module dependencies.
 */

var express = require('express')
  , csv = require('express-csv')
  , routes = require('./routes')
  , http = require('http')
  , path = require('path')
  , bcrypt = require('bcrypt');

var app = module.exports = express();

// all environments
app.set('port', process.env.PORT || 3000);
app.set('views', __dirname + '/views');
app.set('view engine', 'jade');
app.set('export authenticator', function(req, res, callback) { callback(); });
app.use(express.favicon());
app.use(express.logger('dev'));
app.use(express.bodyParser());
app.use(express.methodOverride());
app.use(express.cookieParser('l3ad3rsHipr0x0rzmyb0x0rz'));
app.use(express.session());
app.use(app.router);
app.use(require('stylus').middleware(__dirname + '/public'));
app.use(express.static(path.join(__dirname, 'public')));

// development only
if ('development' == app.get('env')) {
  app.use(express.errorHandler());
}

// production only
if ('production' == app.get('env')) {
  app.set('export authenticator', express.basicAuth(function(user, pass, callback) {
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
