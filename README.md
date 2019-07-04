# Leadership Macon Nomination Form

Welcome to the GitHub homepage for the Leadership Macon Nomination form. This is a simple Node.js application developed to collect nominations and record them in a MongoDB database for later retrieval. It was developed on contract with Leadership Macon and released as Open Source software with their permission.

This app lives in production at [nominate.leadershipmacon.org](http://nominate.leadershipmacon.org) and is hosted at Heroku. It uses Mandrill for notification email delivery, and MongoDB for data persistence.

The app is pretty barebones, but it gets the job done. Specifically, it will:

* Accept input on the form from the user.
* Record nominations in a MongoDB database.
* Deliver an email to the nomination info target email with all the information of the nomination.
* Deliver a confirmation email to the nominator.
* Allow an admin of the app to export nominations to a CSV file for download. (Export is username/password protected in production mode.)

## Using the App

To use this application, you'll need a [MongoDB](http://mongodb.org) instance, and a [Mailgun](http://mailgun.com) account.

The application is designed to be deployed on Heroku. But you can run it on a server of your choosing with the correct configuration or locally for development. The following settings from the environment are understood for configuration purposes:

* **NODE_ENV** - The application environment. When set to "production," a different log format will be used and export will be HTTP basic auth protected.
* **EXPORT_USERNAME** - In production, this is the username you're required to provide on the authentication screen for export.
* **EXPORT_PASSWORD** - In production, this is a BCrypt-encrypted version of the password you're required to provide on the authentication screen for export.
* **MAILGUN_APIKEY** - This is the API key of the Mailgun account the app should use for email delivery.
* **MONGO_URL** - The Mongo URL of the MongoDB instance the app should connect to. Without this specified, the app will attempt to connect to a locally running Mongo instance.
* **NOMINATION_ALERT_EMAIL** - The email that nomination data should be sent to as it flows in.

To start the application, you should just be able to run:

```
$ node app.js
```

... and be off to the races.

## License and Contributions

This application is distributed under the terms of the [Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0). You are free to use this software in compliance with that license.

We welcome contributions and bugs to be filed in the code.
