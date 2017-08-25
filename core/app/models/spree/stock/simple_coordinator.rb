module Spree
  module Stock
    class SimpleCoordinator
      attr_reader :order

      def initialize(order, inventory_units = nil)
        @order = order
        raise "Unimplemented" if inventory_units

        @stock_locations = Spree::StockLocation.all
        @stock_quantities = order.desired_stock_quantities
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

          shipment = Spree::Shipment.new(
            order: order,
            stock_location_id: location_id
          )

          units = []
          units += build_units(shipment: shipment, quantities: on_hand, state: 'on_hand')
          units += build_units(shipment: shipment, quantities: backordered, state: 'backordered')

          package = Spree::Stock::Package.new(
            Spree::StockLocation.find(location_id),
            units.map{|unit| Spree::Stock::ContentItem.new(unit, unit.state) }
          )

          shipment = package.shipment = package.to_shipment
          shipment.shipping_rates = Spree::Config.stock.estimator_class.new.shipping_rates(package)

          shipment
        end.compact
      end

      private

      def build_units(shipment:, quantities:, state:)
        quantities.flat_map do |variant, quantity|
          quantity.times.map do
            shipment.inventory_units.new(
              variant: variant,
              order: order,
              state: state,
              pending: true,
              line_item: Spree::LineItem.last # FIXME: line_item
            )
          end
        end
      end
    end
  end
end
