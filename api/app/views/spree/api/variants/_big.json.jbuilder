
json.(variant, *variant_attributes)
json.partial!("spree/api/variants/small", :variant => variant)
json.total_on_hand(root_object.total_on_hand)
json.variant_properties(variant.variant_properties) do |variant_property|
  json.(variant_property, *variant_property_attributes)
end
json.stock_items(root_object.stock_items.accessible_by(current_ability)) do |stock_item|
  json.(stock_item, :id, :count_on_hand, :stock_location_id, :backorderable)
  json.(stock_item, :available? => :available)
  json.stock_location_name(stock_item.stock_location.name)
end
