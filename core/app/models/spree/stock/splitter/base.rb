module Spree
  module Stock
    module Splitter
      class Base
        attr_reader :packer, :next_splitter

        attr_reader :stock_location

        def initialize(packer_or_stock_location, next_splitter = nil)
          if next_splitter
            Spree::Deprecation.warn("Building a chain of splitters is deprecated. Use each splitter individually")
          end

          if packer_or_stock_location.is_a?(Spree::Stock::Packer)
            @packer = packer_or_stock_location
            @stock_location = packer.stock_location
          else
            raise ArgumentError unless packer_or_stock_location.is_a?(Spree::StockLocation)
            @packer = nil
            @stock_location = packer_or_stock_location
          end
          @next_splitter = next_splitter
        end

        def split(packages)
          return_next(packages)
        end

        private

        def return_next(packages)
          next_splitter ? next_splitter.split(packages) : packages
        end

        def build_package(contents = [])
          Spree::Stock::Package.new(stock_location, contents)
        end
      end
    end
  end
end
