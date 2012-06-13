mongoose = require "mongoose"
Schema = mongoose.Schema

Nomination = new Schema({
  nominee: {
    salutation: String,
    first_name: {type: String, validate: [/^\W+/, 'Nominee first name is required.']},
    middle_name: String,
    last_name: {type: String, validate: [/^\W+/, "Nominee last name is required."]},
    suffix: String,
    organization: {type: String, validate: [/^W+/, "Nominee organization is required."]},
    email: {type: String, validate: [/^W+/, "Nominee email is required."]},
    street_address: {type: String, validate: [/^\W+/, "Nominee street address is required."]},
    city: {type: String, validate: [/^W+/, "Nominee city is required."]},
    zip: Number
  },
  nominator: {
    name: {type: String, validate: [/^\W/, "Nominator name is required."]},
    organization: {type: String, validate: [/^\W/, "Nominator organization is required."]},
    email: {type: String, validate: [/^\W/, "Nominator email is required."]},
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
