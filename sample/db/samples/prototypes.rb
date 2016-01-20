prototypes = [
  {
    name: "Shirt",
    properties: ["Manufacturer", "Brand", "Model", "Shirt Type", "Sleeve Type", "Material", "Fit", "Gender"]
  },
  {
    name: "Bag",
    properties: %w(Type Size Material)
  },
  {
    name: "Mugs",
    properties: %w(Size Type)
  }
]

prototypes.each do |prototype_attrs|
  prototype = Spree::Prototype.create!(name: prototype_attrs[:name])
  prototype_attrs[:properties].each do |property|
    prototype.properties << Spree::Property.find_by_name!(property)
  end
end
