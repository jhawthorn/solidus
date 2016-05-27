require 'spree/core/class_constantizer'

module Spree
  module Core
    module EnvironmentExtension
      extend ActiveSupport::Concern

      class_methods do
        def add_class_set(name)
          attr_reader(name)
          define_method("#{name}=") do |klasses|
            set = ClassConstantizer::Set.new
            set.concat(klasses)
            instance_variable_set("@#{name}", set)
          end
        end
      end

      def add_class(name)
        singleton_class.send(:add_class_set, name)
      end
    end
  end
end
