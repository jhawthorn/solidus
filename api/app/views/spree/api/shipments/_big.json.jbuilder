
json.(shipment, *shipment_attributes)
json.selected_shipping_rate do
  json.partial!("spree/api/shipping_rates/shipping_rate", :shipping_rate => shipment.selected_shipping_rate)
end
json.inventory_units(shipment.inventory_units) do |inventory_unit|
  json.(inventory_unit, *inventory_unit_attributes)
  json.variant do
    json.partial!("spree/api/variants/small", :variant => shipment.variant)
    json.(shipment.variant, :product_id)
    json.images(shipment.images) do |image|
      json.partial!("spree/api/images/image", :image => image)
    end
  end
  json.line_item do
    json.(shipment.line_item, *line_item_attributes)
    json.single_display_amount(shipment.line_item.single_display_amount.to_s)
    json.display_amount(shipment.line_item.display_amount.to_s)
    json.total(shipment.line_item.total)
  end
end
json.order do
  json.partial!("spree/api/orders/order", :order => shipment.order)
  json.bill_address do
    json.partial!("spree/api/addresses/address", :address => shipment.billing_address)
  end
  json.ship_address do
    json.partial!("spree/api/addresses/address", :address => shipment.shipping_address)
  end
  json.adjustments(shipment.adjustments) do |adjustment|
    json.partial!("spree/api/adjustments/adjustment", :adjustment => adjustment)
  end
  json.payments(shipment.payments) do |payment|
    json.(payment, :id, :amount, :display_amount, :state)
    json.source do
      attrs = [:id]
      (attrs << :cc_type) if s.respond_to?(:cc_type)
      json.(shipment.source, *attrs)
    end
    json.payment_method { json.(shipment.payment_method, :id, :name) }
  end
end
