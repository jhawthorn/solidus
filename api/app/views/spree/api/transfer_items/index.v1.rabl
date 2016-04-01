object false
child(@transfer_items => :transfer_items) do
  extends 'spree/api/transfer_items/show'
end
node(:count) { @transfer_items.count }
node(:current_page) { 1 }
node(:pages) { 1 }
