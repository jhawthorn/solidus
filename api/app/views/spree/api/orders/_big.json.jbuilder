json.partial!("spree/api/orders/order", :order => order)
json.payment_methods(order.available_payment_methods) do |payment_method|
  json.(payment_method, :id, :name, :partial_name)
  json.(payment_method, :partial_name, :as => :method_type)
end
json.bill_address do
  json.partial!("spree/api/addresses/address", :address => order.billing_address)
end
json.ship_address do
  json.partial!("spree/api/addresses/address", :address => order.shipping_address)
end
json.line_items(order.line_items) do |line_item|
  json.partial!("spree/api/line_items/line_item", :line_item => line_item)
end
json.payments(order.payments) do |payment|
  json.(payment, *payment_attributes)
  json.payment_method { json.(order.payment_method, :id, :name) }
  json.source do
    json.(order.source, *payment_source_attributes)
    if @current_user_roles.include?("admin") then
      json.(order.source, *(payment_source_attributes + [:gateway_customer_profile_id, :gateway_payment_profile_id]))
    else
      json.(order.source, *payment_source_attributes)
    end
  end
end
json.shipments(order.shipments) do |shipment|
  json.partial!("spree/api/shipments/small", :shipment => shipment)
end
json.adjustments(order.adjustments) do |adjustment|
  json.partial!("spree/api/adjustments/adjustment", :adjustment => adjustment)
end
json.permissions(:can_update => current_ability.can?(:update, adjustment))
json.credit_cards(order.valid_credit_cards) do |credit_card|
  json.partial!("spree/api/credit_cards/credit_card", :credit_card => credit_card)
end
