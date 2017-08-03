object false
child(@stock_movements => :stock_movements) do
  extends 'spree/api/stock_movements/stock_movement'
end
node(:count) { @stock_movements.count }
node(:current_page) { @stock_movements.current_page }
node(:pages) { @stock_movements.total_pages }
