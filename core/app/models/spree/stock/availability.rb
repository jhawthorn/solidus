module Spree
  module Stock
    class Availability
      Value = Struct.new(:stock_location_id, :variant_id, :backorderable, :track_inventory, :count_on_hand)

      def initialize(variant_ids)
        variant_scope = Spree::Variant.where(id: variant_ids.uniq)
        variant_scope.joins!(stock_items: :stock_location)
        variant_scope.merge!(Spree::StockLocation.active)
        values = variant_scope.pluck(:stock_location_id, :variant_id, :backorderable, :track_inventory, :count_on_hand).map do |data|
          # Hack to cast boolean from joined table
          data[2] = [1, 't', true].include?(data[2])

          Value.new(*data)
        end
        @values = values
      end

      def fill_status(variant_id, quantity, stock_location_id: nil)
        values = @values
        values = values.select{|v| v.variant_id == variant_id }
        if stock_location_id
          values = values.select{|v| v.stock_location_id == stock_location_id }
        end

        track_inventory = Config.track_inventory_levels && values.all?(&:track_inventory)
        backorderable = values.any?(&:backorderable)
        total_on_hand = values.sum(&:count_on_hand)

        if !track_inventory
          {
            on_hand: quantity,
            backordered: 0
          }
        elsif backorderable
          {
            on_hand: total_on_hand,
            backordered: quantity - total_on_hand
          }
        else
          {
            on_hand: total_on_hand,
            backordered: 0
          }
        end
      end
    end
  end
end
