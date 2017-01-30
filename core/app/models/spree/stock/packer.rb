module Spree
  module Stock
    class Packer
      attr_reader :stock_location, :inventory_units, :splitters

      def initialize(stock_location, inventory_units, splitters = [Splitter::Base])
        @stock_location = stock_location
        @inventory_units = inventory_units
        @splitters = splitters
      end

      def packages
        if splitters.empty?
          [default_package]
        else
          build_splitter.split [default_package]
        end
      end

      def default_package
        package = Package.new(stock_location)
        availability = Spree::Stock::Availability.new(inventory_units.map(&:variant_id).uniq)
        inventory_units.group_by(&:variant).each do |variant, variant_inventory_units|
          units = variant_inventory_units.clone
          fill_status = availability.fill_status(variant.id, units.count, stock_location_id: stock_location.id)

          on_hand, backordered = fill_status
          package.add_multiple units.slice!(0, on_hand), :on_hand if on_hand > 0
          package.add_multiple units.slice!(0, backordered), :backordered if backordered > 0
        end
        package
      end

      private

      def stock_item_for(variant_id)
        stock_item_lookup[variant_id]
      end

      # Returns a lookup table in the form of:
      #   {<variant_id> => <stock_item>, ...}
      def stock_item_lookup
        @stock_item_lookup ||= Spree::StockItem.
          where(variant_id: inventory_units.map(&:variant_id).uniq).
          where(stock_location_id: stock_location.id).
          map { |stock_item| [stock_item.variant_id, stock_item] }.
          to_h # there is only one stock item per variant in a stock location
      end

      def build_splitter
        splitter = nil
        splitters.reverse_each do |klass|
          splitter = klass.new(self, splitter)
        end
        splitter
      end
    end
  end
end
