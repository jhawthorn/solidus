require 'active_support'
require 'active_support/inflector'
require 'pp'

partials = %W[
spree/api/option_types/show
spree/api/option_values/show
spree/api/products/show
spree/api/stock_locations/show
spree/api/stock_movements/show
spree/api/taxonomies/show
spree/api/taxons/show
spree/api/users/show
spree/api/zones/show
]

partials.each do |show|
  plural_resource_name = File.basename(File.dirname(show))
  singular_resource_name = plural_resource_name.singularize

  partial = show.gsub('show', singular_resource_name)

  content = File.read("app/views/#{show}.v1.rabl")

  object_regex = /^object .*\n/
  File.write("app/views/#{partial}.v1.rabl", content.gsub(object_regex, ''))

  File.write("app/views/#{show}.v1.rabl", <<~RABL)
    #{content[object_regex]}
    extends "#{partial}"
  RABL

  Dir['app/views/**/*.v1.rabl'].each do |file|
    content = File.read(file)
    content.gsub!(show, partial)
    File.write(file, content)
  end

  system("git add app/views")
  system("git commit -am 'Extract #{singular_resource_name} partial'")
end
