json.(address, *address_attributes)
json.country { json.(address.country, *country_attributes) }
json.state { json.(address.state, *state_attributes) }
