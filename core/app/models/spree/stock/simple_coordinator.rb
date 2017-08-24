module Spree
  module Stock
    class SimpleCoordinator
      attr_reader :order, :inventory_units

      def initialize(order, inventory_units = nil)
        @order = order
        @inventory_units = inventory_units || InventoryUnitBuilder.new(order).units
      end
    end
  end
end
