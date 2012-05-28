exports.index = (req, res) ->
  res.render 'index', { title: 'Express' }

exports.nomination = (req, res) ->
  res.render 'nomination', {title: "Nomination"}
