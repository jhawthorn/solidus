object @shipment
cache @shipment
attributes *shipment_attributes

child selected_shipping_rate: :selected_shipping_rate do
  extends "spree/api/shipping_rates/shipping_rate"
end

child inventory_units: :inventory_units do
  object @inventory_unit
  attributes *inventory_unit_attributes

  child :variant do
    extends "spree/api/variants/small"
    attributes :product_id
    child(images: :images) { extends "spree/api/images/image" }
  end

  child :line_item do
    attributes *line_item_attributes
    node(:single_display_amount) { |li| li.single_display_amount.to_s }
    node(:display_amount) { |li| li.display_amount.to_s }
    node(:total) { |li| li.total }
  end
end

child order: :order do
  extends "spree/api/orders/order"

  child billing_address: :bill_address do
    extends "spree/api/addresses/address"
  end

  child shipping_address: :ship_address do
    extends "spree/api/addresses/address"
  end

  child adjustments: :adjustments do
    extends "spree/api/adjustments/adjustment"
  end

  child payments: :payments do
    attributes :id, :amount, :display_amount, :state
    child source: :source do |s|
      attrs = [:id]
      if s.respond_to?(:cc_type)
        attrs << :cc_type
      end
      attributes *attrs
    end
    child payment_method: :payment_method do
      attributes :id, :name
    end
  end
end
