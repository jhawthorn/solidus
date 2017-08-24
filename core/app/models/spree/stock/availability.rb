module Spree
  module Stock
    class Availability
      def initialize(variants:, stock_locations: Spree::StockLocation.active)
        @variants = variants
        @stock_locations = stock_locations
      end

      def counts_on_hand
        stock_item_scope.
          group(:variant_id, :stock_location_id).
          sum(:count_on_hand)
      end

      def backorderables
        stock_item_scope.
          where(backorderable: true).
          pluck(:stock_location_id, :variant_id)
      end

      private

      def stock_item_scope
        Spree::StockItem.
          where(variant_id: inventory_variants.map(&:id)).
          where(stock_location_id: @stock_locations)
      end

      def inventory_variants
        @variants.select(&:track_inventory?)
      end
    end
  end
end
