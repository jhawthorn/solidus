json.array! @user_addresses do |user_address|
  json.partial!("spree/api/addresses/show", address: user_address.address)

  json.default user_address.default
  json.update_target user_address.update_target
end
