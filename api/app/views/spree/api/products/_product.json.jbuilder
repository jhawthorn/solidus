@product_attributes ||= product_attributes
json.(product, *@product_attributes)
json.display_price(product.display_price.to_s)
@exclude_data ||= {}
unless @exclude_data[:variants] then
  json.has_variants(product.has_variants?)
  json.master do
    json.partial!("spree/api/variants/small", :variant => product.master)
  end
  json.variants(product.variants) do |variant|
    json.partial!("spree/api/variants/small", :variant => variant)
  end
end
unless @exclude_data[:option_types] then
  json.option_types(product.option_types) do |option_type|
    json.(option_type, *option_type_attributes)
  end
end
unless @exclude_data[:product_properties] then
  json.product_properties(product.product_properties) do |product_property|
    json.(product_property, *product_property_attributes)
  end
end
unless @exclude_data[:classifications] then
  json.classifications(product.classifications) do |classification|
    json.(classification, :taxon_id, :position)
    json.taxon do
      json.partial!("spree/api/taxons/taxon", :taxon => product.taxon)
    end
  end
end
