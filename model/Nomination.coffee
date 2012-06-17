mongoose = require "mongoose"
Schema = mongoose.Schema

Nomination = new Schema({
  nominee: {
    salutation: String,
    first_name: {type: String, validate: [/^\w+/, 'Nominee first name is required.']},
    middle_name: String,
    last_name: {type: String, validate: [/^\w+/, "Nominee last name is required."]},
    suffix: String,
    organization: {type: String, validate: [/^\w+/, "Nominee organization is required."]},
    email: {type: String, validate: [/^\w+/, "Nominee email is required."]},
    street_address: {type: String, validate: [/^\w+/, "Nominee street address is required."]},
    city: {type: String, validate: [/^\w+/, "Nominee city is required."]},
    zip: {type: String, validate: [/^\d\d\d\d\d$/, "ZIP code must be five digits."]}
  },
  nominator: {
    name: {type: String, validate: [/^\w/, "Nominator name is required."]},
    organization: {type: String, validate: [/^\w/, "Nominator organization is required."]},
    email: {type: String, validate: [/^\w/, "Nominator email is required."]},
    phone: {type: String, validate: [/^\w/, "Nominator phone number is required."]}
  },
  nomination_reason: {type: String, validate: [/^\w/, "Nomination reason is required."]},
  good_leader_reason: {type: String, validate: [/^\w/, "The reason the nominee is a good leader is required."]},
  num_years_known: {type: String, validate: [/^\w/, "The number of years you have known the nominee is required."]},
  personally_observed_leadership: String,
  leadership_skills_observed: String,
  nominee_notified: String
})

mongoose.model("Nomination", Nomination)
