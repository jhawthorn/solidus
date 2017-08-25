module Spree
  module Stock
    class SimpleCoordinator
      attr_reader :order

      def initialize(order, inventory_units = nil)
        @order = order
        @inventory_units = inventory_units || InventoryUnitBuilder.new(order).units
        @inventory_units_by_variant = @inventory_units.group_by(&:variant)

        @stock_locations = Spree::StockLocation.all
        @stock_quantities = Spree::StockQuantities.new(@inventory_units_by_variant.transform_values(&:count))
        @availability = Spree::Stock::Availability.new(variants: @stock_quantities.variants)
      end

      def shipments
        desired = @stock_quantities
        on_hand_packages =
          @availability.on_hand_by_location.transform_values do |available|
            packaged = available & desired
            desired -= packaged
            packaged
          end
        backordered_packages =
          @availability.backorderable_by_location.transform_values do |available|
            packaged = available & desired
            desired -= packaged
            packaged
          end

        unless desired.empty?
          raise Spree::Order::InsufficientStock
        end

        (on_hand_packages.keys | backordered_packages.keys).map do |location_id|
          on_hand = on_hand_packages[location_id]
          backordered = backordered_packages[location_id]

          next if on_hand.empty? && backordered.empty?

          package = Spree::Stock::Package.new(Spree::StockLocation.find(location_id))

          package.add_multiple(get_units(on_hand), :on_hand)
          package.add_multiple(get_units(backordered), :backordered)

          shipment = package.shipment = package.to_shipment
          shipment.shipping_rates = Spree::Config.stock.estimator_class.new.shipping_rates(package)

          shipment
        end.compact
      end

      private

      def get_units(quantities)
        quantities.flat_map do |variant, quantity|
          @inventory_units_by_variant[variant].shift(quantity)
        end
      end
    end
  end
end
