module Spree
  module Stock
    class Availability
      def initialize
      end

      def fill_status(variant, quantity, stock_location: nil)
        quantifier = Spree::Stock::Quantifier.new(variant, stock_location)
        total_on_hand = quantifier.total_on_hand
        total_on_hand = [total_on_hand, quantity].min
        if quantifier.backorderable?
          [total_on_hand, quantity - total_on_hand]
        else
          [total_on_hand, 0]
        end
      end
    end
  end
end
