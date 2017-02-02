attributes *taxonomy_attributes

child :root => :root do |taxon|
  attributes *taxon_attributes

  child (taxon.with_preloaded_tree.children) => :taxons do
    attributes *taxon_attributes

    extends "spree/api/taxons/taxons"
  end
end
