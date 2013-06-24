exports.build = function(app) {
  var mongodb = require('mongodb'),
      MongoClient = mongodb.MongoClient,
      mongoUrl = process.env.MONGOHQ_URL || "mongodb://127.0.0.1:27017/lmnominations-dev",
      Mandrill = require('mandrill-api').Mandrill;

  /**
   * Homepage.
  **/
  function index(req, res){
    res.render("index", {
      title: "Leadership Macon 2014 Nomination Form"
    });
  };

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
