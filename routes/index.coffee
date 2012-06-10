mongoose = require 'mongoose'
Nomination = mongoose.model("Nomination")
nodemailer = require 'nodemailer'

emailTransport = nodemailer.createTransport "SES",
  AWSAccessKeyID: process.env.AWSACCESSKEY,
  AWSSecretKey: process.env.AWSSECRETKEY

exports.index = (req, res) ->
  res.render 'index', { title: 'Express' }

exports.nomination = (req, res) ->
  res.render 'nomination', {title: "Nomination"}

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
              console.log("Email error occured")
              console.log(emailError.message)
        else
          console.log templateErr

      ###
      emailTransport.sendMail {
        from: 'Leadership Macon <noreply@nominate.leadershipmacon.org>',
        to: 'Leadership Macon <matt.foxtrot@gmail.com>',
        subject: 'Nomination Notification',
        text: 'Test message.'
      }, (emailError) ->
        if (emailError)
          console.log("Email error occured.")
          console.log(emailError.message)
      ###

      res.redirect "/nomination"
    else
      console.log(err)
      res.redirect "/nomination"
