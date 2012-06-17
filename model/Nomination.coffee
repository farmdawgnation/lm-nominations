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
    zip: {type: String, validate: [/^\d\d\d\d\d$/, "ZIP code must be five digits."]}
  },
  nominator: {
    name: {type: String, validate: [/^\W/, "Nominator name is required."]},
    organization: {type: String, validate: [/^\W/, "Nominator organization is required."]},
    email: {type: String, validate: [/^\W/, "Nominator email is required."]},
    phone: {type: String, validate: [/^\W/, "Nominator phone number is required."]}
  },
  nomination_reason: {type: String, validate: [/^\W/, "Nomination reason is required."]},
  good_leader_reason: {type: String, validate: [/^\W/, "The reason the nominee is a good leader is required."]},
  num_years_known: {type: String, validate: [/^\W/, "The number of years you have known the nominee is required."]},
  personally_observed_leadership: Boolean,
  leadership_skills_observed: String,
  nominee_notified: Boolean
})

mongoose.model("Nomination", Nomination)
