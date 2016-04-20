module Spree
  module Preferences
    module StaticallyConfigurable
      extend ActiveSupport::Concern

      class_methods do
        def preference_sources
          Spree::Config.static_model_preferences.for_class(self)
        end

        def available_preference_sources
          preference_sources.keys
        end
      end

      # override assignment to cast empty string to nil
      def preference_source=(val)
        super(val.presence)
      end

      def preferences
        if respond_to?(:preference_source) && preference_source
          self.class.preference_sources[preference_source] || {}
        elsif defined?(super)
          super
        else
          {}
        end
      end

      def preferences=(val)
        if respond_to?(:preference_source) && preference_source
        elsif defined?(super)
          super
        end
      end
    end
  end
end
