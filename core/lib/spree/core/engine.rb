require 'spree/config'

module Spree
  module Core
    class Engine < ::Rails::Engine
      isolate_namespace Spree
      engine_name 'spree'

      config.generators do |g|
        g.test_framework :rspec
      end

      initializer "spree.environment", before: :load_config_initializers do |app|
        app.config.spree = Spree::Config.environment
      end

      initializer "spree.default_permissions", before: :load_config_initializers do |_app|
        Spree::RoleConfiguration.configure do |config|
          config.assign_permissions :default, ['Spree::PermissionSets::DefaultCustomer']
          config.assign_permissions :admin, ['Spree::PermissionSets::SuperUser']
        end
      end

      # leave empty initializers for backwards-compatability. Other apps might still rely on these events
      initializer "spree.register.calculators", before: :load_config_initializers do; end
      initializer "spree.register.stock_splitters", before: :load_config_initializers do; end
      initializer "spree.register.payment_methods", before: :load_config_initializers do; end
      initializer 'spree.promo.environment', before: :load_config_initializers do; end
      initializer 'spree.promo.register.promotion.calculators', before: :load_config_initializers do; end
      initializer 'spree.promo.register.promotion.rules', before: :load_config_initializers do; end
      initializer 'spree.promo.register.promotions.actions', before: :load_config_initializers do; end
      initializer 'spree.promo.register.promotions.shipping_actions', before: :load_config_initializers do; end

      # Filter sensitive information during logging
      initializer "spree.params.filter", before: :load_config_initializers do |app|
        app.config.filter_parameters += [
          %r{^password$},
          %r{^password_confirmation$},
          %r{^number$}, # Credit Card number
          %r{^verification_value$} # Credit Card verification value
        ]
      end

      initializer "spree.core.checking_migrations", before: :load_config_initializers do |_app|
        Migrations.new(config, engine_name).check
      end

      # Load in mailer previews for apps to use in development.
      # We need to make sure we call `Preview.all` before requiring our
      # previews, otherwise any previews the app attempts to add need to be
      # manually required.
      if Rails.env.development?
        initializer "spree.mailer_previews" do
          ActionMailer::Preview.all
          Dir[root.join("lib/spree/mailer_previews/**/*_preview.rb")].each do |file|
            require_dependency file
          end
        end
      end
    end
  end
end
