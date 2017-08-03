if (params[:set] == "nested") then
  json.partial!("spree/api/taxonomies/nested", :taxonomy => taxonomy)
else
  json.(taxonomy, *taxonomy_attributes)
  json.root do
    json.(taxonomy.root, *taxon_attributes)
    json.taxons(taxonomy.children) { |taxon| json.(taxon, *taxon_attributes) }
  end
end