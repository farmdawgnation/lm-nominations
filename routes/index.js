exports.build = function(app) {
  var mongodb = require('mongodb'),
      MongoClient = mongodb.MongoClient,
      mongoUrl = process.env.MONGOHQ_URL || "mongodb://127.0.0.1:27017/lmnominations-dev",
      Mandrill = require('mandrill-api').Mandrill,
      mandrillApi = new Mandrill(),
      nominationInfoTargetEmail = process.env.NOMINATION_ALERT_EMAIL || "matt+nominfo@frmr.me";

  /**
   * Homepage.
  **/
  function index(req, res){
    res.render("index", {
      title: "Leadership Macon 2014 Nomination Form"
    });
  }

  function sendNominationInfoEmail(nomination) {
    var data = {
      nominationFields: nomination
    };

    app.render("emails/nomination-info", data, function(err, html) {
      if (err) throw err;

      mandrillApi.messages.send({
        message: {
          html: html,
          subject: "New Nomination for LM 2014",
          to: [
            {
              email: nominationInfoTargetEmail,
              name: "Leadership Macon"
            }
          ]
        }
      });
    });
  }

  function sendConfirmationEmail(to, nominatorName, nomineeName) {
    var data = {
      nominatorName: nominatorName,
      nomineeName: nomineeName
    };

    app.render("emails/confirmation", data, function(err, html) {
      if (err) throw err;

      mandrillApi.messages.send({
        message: {
          html: html,
          subject: "Thank you for your Nomination!",
          to: [
            {
              email: to,
              name: nominatorName
            }
          ]
        }
      });
    });
  }

  /**
   * Take in a nomination submission and store it in the
   * MongoDB database.
  **/
  function submit(req, res) {
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
   * Nomination submission processing.
  **/

  // Build routes.
  app.get("/", index);
  app.post("/", submit);
}
