
json.(@stock_transfer, *stock_transfer_attributes)
json.received_item(partial("spree/api/transfer_items/show", :object => (@transfer_item)))
