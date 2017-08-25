module Spree
  # A value object to hold quantities of several variants
  class StockQuantities
    attr_reader :quantities
    include Enumerable

    def initialize(quantities={})
      raise ArgumentError unless quantities.keys.all?{|v| v.is_a?(Spree::Variant) }

      @quantities = quantities
    end

    def each(&block)
      @quantities.each(&block)
    end

    def [](variant)
      @quantities[variant]
    end

    def variants
      @quantities.keys.uniq
    end

    def merge(other, &block)
      self.class.new quantities.merge(other.quantities, &block)
    end

    def +(other)
      merge(other) do |variant, a, b|
        a + b
      end
    end

    def -(other)
      merge(other) do |variant, a, b|
        a - b
      end
    end

    def &(other)
      self.class.new map { |(variant, quantity)|
        next unless other[variant]
        [variant, [other[variant], quantity].min]
      }.compact.to_h
    end

    def empty?
      @quantities.values.all?(&:zero?)
    end
  end
end
