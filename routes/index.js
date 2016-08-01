exports.build = function(app) {
  var mongodb = require('mongodb'),
      MongoClient = mongodb.MongoClient,
      mongoUrl = process.env.MONGOHQ_URL || "mongodb://127.0.0.1:27017/lmnominations-dev",
      Mailgun = require('mailgun').Mailgun,
      mailgunApi = new Mailgun(process.env.MAILGUN_API_KEY),
      mailcomposer = require("mailcomposer"),
      nominationInfoTargetEmail = process.env.NOMINATION_ALERT_EMAIL || "matt+nominfo@frmr.me",
      exportAuth = app.get('export authenticator');

  /**
   * Homepage.
  **/
  function index(req, res){
    res.render("index", {
      title: "Leadership Macon 2017 Nomination Form"
    });
  }

  function sendNominationInfoEmail(nomination) {
    var data = {
      nominationFields: nomination
    };

    app.render("emails/nomination-info", data, function(err, renderedEmail) {
      if (err) throw err;

      let mailOptions = {
        from: 'Leadership Macon <noreply@leadershipmacon.org>',
        to: 'Leadership Macon <' + nominationInfoTargetEmail + '>',
        subject: 'New Nomination for LM 2017',
        html: renderedEmail
      };

      mailcomposer(mailOptions).build(function(err, message) {
        if (err) throw err;

        mailgunApi.sendRaw('noreply@leadershipmacon.org', nominationInfoTargetEmail, message);
      });
    });
  }

  function sendConfirmationEmail(nominatorEmail, nominatorName, nomineeName) {
    var data = {
      nominatorName: nominatorName,
      nomineeName: nomineeName
    };

    app.render("emails/confirmation", data, function(err, renderedEmail) {
      if (err) throw err;

      let mailOptions = {
        from: 'Leadership Macon <noreply@leadershipmacon.org>',
        to: nominatorName + ' <' + nominatorEmail + '>',
        subject: 'Thank you for your nomination!',
        html: renderedEmail
      };

      mailcomposer(mailOptions).build(function(err, message) {
        if (err) throw err;

        mailgunApi.sendRaw('noreply@leadershipmacon.org', nominatorEmail, message);
      });
    });
  }

  /**
   * Take in a nomination submission and store it in the
   * MongoDB database.
  **/
  function submit(req, res) {
    var allowedKeys = [
      "nominee-salutation",
      "nominee-first-name",
      "nominee-middle-name",
      "nominee-last-name",
      "nominee-suffix",
      "nominee-organization",
      "nominee-email",
      "nominee-street-address",
      "nominee-city",
      "nominee-state",
      "nominee-zip",
      "nominator-first-name",
      "nominator-last-name",
      "nominator-organization",
      "nominator-email",
      "nominator-phone",
      "details-nomination-reason",
      "details-good-leader",
      "details-years-known",
      "details-personally-observed-leadership",
      "details-leadership-skills",
      "details-notified-nominee"
    ];

    Object.keys(req.body).forEach(function(key) {
      if (allowedKeys.indexOf(key) == -1) {
        console.log("Throwing away key " + key + " from submission.");
        delete req.body[key];
      }
    });

    MongoClient.connect(mongoUrl, function(err, db) {
      if (err) throw err;

      db.collection("nominations").insert(req.body, function(err, docs) {
        db.close();

        if (err) throw err;

        sendNominationInfoEmail(req.body);
        sendConfirmationEmail(
          req.body["nominator-email"],
          req.body["nominator-first-name"] + " " + req.body["nominator-last-name"],
          req.body["nominee-first-name"] + " " + req.body["nominee-last-name"]
        );

        res.render("thanks", {
          title: "Thank you!"
        });
      });
    });
  }

  /**
   * Produce a CSV export of the data in the Mongo database.
  **/
  function exportNominations(req, res) {
    var nominations = [];
    var keys = [];

    MongoClient.connect(mongoUrl, function(err, db) {
      if (err) throw err;

      var stream = db.collection("nominations").find().stream();

      stream.on('data', function(item) {
        // We're not guaranteed all keys will exist in all nominations
        // so we record all the keys we see for later.
        for (key in item) {
          if (keys.indexOf(key) == -1)
            keys.push(key);
        }

        nominations.push(item);
      });

      stream.on('end', function() {
        var resultSet = [keys];

        // We're not guaranteed all keys will be present or that all keys
        // will be present in the same order. So, we need to make sure that
        // we're intentional about how they appear in the csv.
        nominations.forEach(function(nomination) {
          var resultRow = [];

          keys.forEach(function(key) {
            resultRow.push(nomination[key] || "");
          });

          resultSet.push(resultRow);
        });

        res.csv(resultSet);
        db.close();
      });
    });
  }

  /**
   * Nomination submission processing.
  **/

  // Build routes.
  app.get("/", index);
  app.post("/", submit);
  app.get("/export", exportAuth, exportNominations);
}
