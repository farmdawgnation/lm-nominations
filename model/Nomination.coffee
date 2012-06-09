mongoose = require "mongoose"
Schema = mongoose.Schema

Nomination = new Schema({
  nominee: {
    salutation: String,
    first_name: String,
    middle_name: String,
    last_name: String,
    suffix: String,
    organization: String,
    email: String,
    street_address: String,
    city: String,
    zip: Number
  },
  nominator: {
    name: String,
    organization: String,
    email: String,
    phone: Number
  },
  nomination_reason: String,
  good_leader_reason: String,
  num_years_known: String,
  personally_observed_leadership: Boolean,
  leadership_skills_observed: String,
  nominee_notified: Boolean
})

mongoose.model("Nomination", Nomination)
