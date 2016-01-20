module Spree
  module Admin
    class StyleGuideController < Spree::Admin::BaseController
      respond_to :html
      layout '/spree/layouts/admin_style_guide'

      def index
        @topics = {
          typography: %w(
            fonts
            colors
            lists
            icons
            tags),
          forms: %w(
            building_forms
            validation),
          messaging: %w(
            loading
            flashes
            tooltips),
          tables: %w(
            building_tables
            pagination)
        }
      end
    end
  end
end
