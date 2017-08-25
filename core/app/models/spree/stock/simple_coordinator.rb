module Spree
  module Stock
    class SimpleCoordinator
      attr_reader :order

      def initialize(order, inventory_units = nil)
        @order = order
        @inventory_units = inventory_units || InventoryUnitBuilder.new(order).units
        @inventory_units_by_variant = @inventory_units.group_by(&:variant)

        @stock_locations = Spree::StockLocation.all
        @desired = Spree::StockQuantities.new(@inventory_units_by_variant.transform_values(&:count))
        @availability = Spree::Stock::Availability.new(variants: @desired.variants)
      end

      def shipments
        @shipments ||= build_shipments
      end

      private

      def build_shipments
        on_hand_packages = allocate_inventory(@availability.on_hand_by_location)
        backordered_packages = allocate_inventory(@availability.backorderable_by_location)

        unless @desired.empty?
          raise Spree::Order::InsufficientStock
        end

        stock_locations = Spree::StockLocation.find(on_hand_packages.keys | backordered_packages.keys)

        stock_locations.map do |stock_location|
          on_hand = on_hand_packages[stock_location.id]
          backordered = backordered_packages[stock_location.id]

          next if on_hand.empty? && backordered.empty?

          package = Spree::Stock::Package.new(stock_location)

          package.add_multiple(get_units(on_hand), :on_hand)
          package.add_multiple(get_units(backordered), :backordered)

          shipment = package.shipment = package.to_shipment
          shipment.shipping_rates = Spree::Config.stock.estimator_class.new.shipping_rates(package)

          shipment
        end.compact
      end

      def allocate_inventory(availability_by_location)
        availability_by_location.transform_values do |available|
          packaged = available & @desired
          @desired -= packaged
          packaged
        end
      end

      def get_units(quantities)
        quantities.flat_map do |variant, quantity|
          @inventory_units_by_variant[variant].shift(quantity)
        end
      end
    end
  end
end
