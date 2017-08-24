module Spree
  # A value object to hold quantities of several variants
  class StockQuantities
    attr_reader :quantities

    def initialize(quantities={})
      @quantities = quantities
    end

    def each(&block)
      @quantities.each(&block)
    end

    def variants
      @quantities.keys.uniq
    end

    def merge(other, &block)
      quantities.merge(other.quantities, &block)
    end

    def +(other)
      merge(other) do |(a, b)|
        a + b
      end
    end
  end
end
