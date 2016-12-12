require_dependency 'spree/shipping_calculator'

module Spree
  module Calculator::Shipping
    class FlexiRate < ShippingCalculator
      preference :first_item,      :decimal, default: 0.0
      preference :additional_item, :decimal, default: 0.0
      preference :max_items,       :integer, default: 0
      preference :currency,        :string,  default: ->{ Spree::Config[:currency] }

      def compute_package(package)
        compute_from_quantity(package.contents.sum(&:quantity))
      end

      def compute_from_quantity(quantity)
        items_count = quantity
        items_count = [items_count, preferred_max_items].min unless preferred_max_items.zero?

        return BigDecimal.new(0) if items_count == 0

        additional_items_count = items_count - 1
        preferred_first_item + preferred_additional_item * additional_items_count
      end
    end
  end
end
