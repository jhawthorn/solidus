module Spree
  module Stock
    class Availability
      def initialize(variants:, stock_locations: Spree::StockLocation.active)
        @variants = variants
        @variant_map = variants.index_by(&:id)
        @stock_locations = stock_locations
      end

      Item = Struct.new(:variant, :stock_location_id, :count_on_hand, :backorderable) do
        def variant_id
          variant.id
        end
      end

      def on_hand_by_location
        items.group_by(&:stock_location_id).transform_values do |location_items|
          Spree::StockQuantities.new(
            location_items.map do |item|
              [item.variant, item.count_on_hand]
            end.to_h
          )
        end.to_h
      end

      def backorderable_by_location
        items.group_by(&:stock_location_id).transform_values do |location_items|
          Spree::StockQuantities.new(
            location_items.map do |item|
              [item.variant, item.backorderable ? Float::INFINITY : 0]
            end.to_h
          )
        end.to_h
      end

      private

      def items
        @items ||=
          counts_on_hand.map do |(variant_id, stock_location_id), count_on_hand|
            variant = @variant_map[variant_id]
            backorderable = backorderables.include?([variant_id, stock_location_id])
            count_on_hand = Float::INFINITY if !variant.track_inventory?
            count_on_hand = 0 if count_on_hand < 0
            Item.new(variant, stock_location_id, count_on_hand, backorderable)
          end
      end

      def counts_on_hand
        @counts_on_hand ||=
          stock_item_scope.
            group(:variant_id, :stock_location_id).
            sum(:count_on_hand)
      end

      def backorderables
        @backorderables ||=
          stock_item_scope.
            where(backorderable: true).
            pluck(:variant_id, :stock_location_id)
      end

      def find(variant_id:, stock_location_id:)
        items.detect do |item|
          item.variant_id == variant_id && item.stock_location_id == stock_location_id
        end
      end

      def stock_item_scope
        Spree::StockItem.
          where(variant_id: @variants).
          where(stock_location_id: @stock_locations)
      end
    end
  end
end
