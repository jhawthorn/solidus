
json.(@shipment, *shipment_attributes)
json.order_id(@shipment.order.number)
json.stock_location_name(@shipment.stock_location.name)
json.shipping_rates(@shipment.shipping_rates) do |shipping_rate|
  json.partial!("spree/api/shipping_rates/shipping_rate", :shipping_rate => shipping_rate)
end
json.selected_shipping_rate do
  json.partial!("spree/api/shipping_rates/shipping_rate", :shipping_rate => @shipment.selected_shipping_rate)
end
json.shipping_methods(@shipment.shipping_methods) do |shipping_method|
  json.(shipping_method, :id, :name)
  json.zones(@shipment.zones) { |zone| json.(zone, :id, :name, :description) }
  json.shipping_categories(@shipment.shipping_categories) do |shipping_category|
    json.(shipping_category, :id, :name)
  end
end
json.manifest do
  json.variant do
    json.partial!("spree/api/variants/small", :variant => @shipment.variant)
  end
  json.quantity(@shipment.manifest.quantity)
  json.states(@shipment.manifest.states)
end
