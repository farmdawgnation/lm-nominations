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
  console.log req.body.nomination
  new_nomination = new Nomination req.body.nomination
  new_nomination.save (err) ->
    unless err
      emailTransport.sendMail {
        from: 'Leadership Macon <matt.foxtrot@gmail.com>',
        to: 'Nominator <matt.foxtrot@gmail.com>',
        subject: 'Thank you for your nomination.',
        text: 'Test message.'
      }, (emailError) ->
        if (emailError)
          console.log("Email error occured")
          console.log(emailError.message)

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
