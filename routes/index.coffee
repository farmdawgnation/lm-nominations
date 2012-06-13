mongoose = require 'mongoose'
Nomination = mongoose.model("Nomination")
nodemailer = require 'nodemailer'

emailTransport = nodemailer.createTransport "SES",
  AWSAccessKeyID: process.env.AWSACCESSKEY,
  AWSSecretKey: process.env.AWSSECRETKEY

exports.index = (req, res) ->
  res.render 'nomination', {
    title: 'Nomination',
    success: req.flash("success"),
    error: req.flash("error")
  }

exports.submit = (req, res) ->
  new_nomination = new Nomination req.body.nomination
  new_nomination.save (err) ->
    unless err
      nominator = new_nomination.nominator.name
      nominee = new_nomination.nominee.first_name + " " + new_nomination.nominee.last_name

      res.render 'nomthanksemail', {
        layout: false,
        nominator: nominator,
        nominee: nominee
      }, (templateErr, emailHtml) ->
        if ! templateErr
          emailTransport.sendMail {
            from: 'Leadership Macon <nominations@leadershipmacon.org>',
            replyTo: 'Lynn Farmer <lfarmer@maconchamber.org>',
            to: 'Nominator <matt.foxtrot@gmail.com>',
            subject: 'Thank you for your nomination.',
            generateTextFromHTML: true,
            html: emailHtml
          }, (emailError) ->
            if (emailError)
              req.flash "error", "A problem occured delivering your confirmation email. This error has been logged. Your nomination was still recorded."
              console.log(emailError.message)
        else
          req.flash "error", "A problem occured delivering your confirmation email. This error has been logged. Your nomination was still recorded."
          console.log templateErr

      ###
      emailTransport.sendMail {
        from: 'Leadership Macon <noreply@nominate.leadershipmacon.org>',
        to: 'Leadership Macon <matt.foxtrot@gmail.com>',
        subject: 'Nomination Notification',
        text: 'Test message.'
      }, (emailError) ->
        if (emailError)
          console.log("Error occured generating notification email to LM.")
          console.log(emailError.message)
      ###

      req.flash "success", "Your nomination was successfully submitted."
      res.redirect "/"
    else
      req.flash "error", err
      res.render 'nomination', {
        nomination: new_nomination,
        title: "Nomination",
        success: req.flash("success"),
        error: req.flash("error")
      }
