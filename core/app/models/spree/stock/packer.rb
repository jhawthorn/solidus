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
          statuses = availability.fill_status(variant.id, units.count, stock_location_id: stock_location.id)

          package.add_multiple units.slice!(0, statuses[:on_hand]), :on_hand if statuses[:on_hand] > 0
          package.add_multiple units.slice!(0, statuses[:backordered]), :backordered if statuses[:backordered] > 0
        end
        package
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
