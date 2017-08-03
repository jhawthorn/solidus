json.(stock_location, *stock_location_attributes)
json.country { json.(stock_location.country, *country_attributes) }
json.state { json.(stock_location.state, *state_attributes) }
