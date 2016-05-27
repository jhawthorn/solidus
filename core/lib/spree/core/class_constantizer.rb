module Spree
  module ClassConstantizer
    class Collection
      include Enumerable

      def <<(klass)
        @collection << klass.to_s
      end

      def concat(klasses)
        klasses.each do |klass|
          self << klass
        end
      end

      delegate :clear, :empty?, to: :@collection

      def each(&block)
        @collection.each do |klass|
          yield klass.constantize
        end
      end
    end

    class Set < Collection
      def initialize
        @collection = ::Set.new
      end
    end
  end
end
