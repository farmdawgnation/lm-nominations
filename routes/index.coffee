mongoose = require 'mongoose'
Nomination = mongoose.model("Nomination")

exports.index = (req, res) ->
  res.render 'index', { title: 'Express' }

exports.nomination = (req, res) ->
  res.render 'nomination', {title: "Nomination"}

exports.submit = (req, res) ->
  console.log req.body.nomination
  new_nomination = new Nomination req.body.nomination
  new_nomination.save (err) ->
    console.log(err)

  res.redirect "/"
