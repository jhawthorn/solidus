
attributes *user_attributes
child(:bill_address => :bill_address) do
  extends "spree/api/addresses/address"
end

child(:ship_address => :ship_address) do
  extends "spree/api/addresses/address"
end