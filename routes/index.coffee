mongoose = require 'mongoose'
Nomination = mongoose.model("Nomination")
nodemailer = require 'nodemailer'
$ = require "jQuery"
XMLHttpRequest = require("xmlhttprequest").XMLHttpRequest

emailTransport = nodemailer.createTransport "SES",
  AWSAccessKeyID: process.env.AWS_ACCESSKEY,
  AWSSecretKey: process.env.AWS_SECRETKEY

# Build out the object we're going to pass to the renderer
buildRendererParams = (req, additionalParamsObject) ->
  returnObject = {
    success: req.flash("success"),
    error: req.flash("error"),
    recaptcha: {public_key: process.env.RECAPTCHA_PUBLIC_KEY},
    nomination: new Nomination(),
    validations: {}
  }

  returnObject[key] = value for key, value of additionalParamsObject

  returnObject

plaintextRecaptchaError = (error) ->
  if error == "invalid-site-private-key"
    "ReCAPTCHA failed due to invalid private key. Please contact the site admins."
  else if error == "invalid-request-cookie"
    "Something went bad with the ReCAPTCHA challenge. Please try again."
  else if error == "incorrect-captcha-sol"
    "Your CAPTCHA solution was incorrect."
  else if error == "recaptcha-not-reachable"
    "We couldn't verify your CAPTCHA response because ReCAPTCHA appears to be offline."
  else
    "The ReCAPTCHA failed for some unknown reason: " + error

# GET /
exports.index = (req, res) ->
  res.render 'nomination', buildRendererParams(req, {})

# POST /submit
exports.submit = (req, res) ->
  # Workaround for the Same Origin Policy being enforced
  # by jQuery. This allows us to do our ReCAPTCHA API call
  # using the uber sexy $.ajax syntax.
  $.support.cors = true;
  $.ajaxSettings.xhr = () ->
      return new XMLHttpRequest

  # Create the Nomination object from the input.
  req.body.nomination.ip_address = req.headers['X-Real-IP'] || "127.0.0.1"
  new_nomination = new Nomination req.body.nomination

  $.ajax
    url: "http://www.google.com/recaptcha/api/verify"
    type: "post"
    dataType: "text"
    data: {
      privatekey: process.env.RECAPTCHA_PRIVATE_KEY,
      remoteip: req.headers['X-Real-IP'] || "127.0.0.1",
      challenge: req.body.recaptcha_challenge_field,
      response: req.body.recaptcha_response_field
    }
    success: (data) ->
      dataParts = data.split("\n")

      if dataParts[0] == "false"
        req.flash('error', plaintextRecaptchaError(dataParts[1]))
        res.render 'nomination', buildRendererParams req,
          nomination: new_nomination

        return

      # Attempt to save the nomination object in the DB.
      new_nomination.save (saveErr) ->
        unless saveErr
          # Send notification emails to the nominator
          nominator = new_nomination.nominator.name
          nominator_mailing_address = nominator + " <" + new_nomination.nominator.email + ">"
          nominee = new_nomination.nominee.first_name + " " + new_nomination.nominee.last_name

          # Send the thank you email to the person who created
          # the nomination.
          res.render 'nomthanksemail', {
            layout: false,
            nominator: nominator,
            nominee: nominee
          }, (templateErr, emailHtml) ->
            if ! templateErr
              emailTransport.sendMail {
                from: 'Leadership Macon <nominations@leadershipmacon.org>',
                replyTo: 'Lynn Farmer <lfarmer@maconchamber.org>',
                to: nominator_mailing_address,
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

          # Send an email to Leadership Macon notifying them
          # of the new nomination.
          emailTransport.sendMail {
            from: 'Leadership Macon <nominations@leadershipmacon.org>',
            to: 'Lynn Farmer <lfarmer@maconchamber.com>, Matt Farmer <matt@frmr.me>',
            subject: 'New Nomination: ' + nominee,
            text: "A new nomination has been recorded in the database for " + nominee + ". This person was nominated by " + nominator + "."
          }, (emailError) ->
            if (emailError)
              console.log("An error occured generated LM email: " + emailError)

          # Notify the user the email was successful.
          req.flash "success", "Your nomination was successfully submitted."
          res.redirect "/"
        else
          req.flash "error", "Something went wrong: " + saveErr.message unless saveErr.errors

          res.render 'nomination', buildRendererParams(req, {
            nomination: req.body.nomination,
            validations: saveErr.errors || {}
          })
    error: (xhrreq, status, errorThrown) ->
      console.error("ReCAPTCHA request errored: " + status)
      req.flash('error', "The ReCAPTCHA service responded with error: " + status + " " + errorThrown)
      res.render 'nomination', buildRendererParams req,
        nomination: new_nomination
