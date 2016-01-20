module Spree
  module Admin
    class StockLocationsController < ResourceController
      before_action :set_country, only: :new

      private

      def set_country
        @stock_location.country = if Spree::Config[:default_country_id].present?
                                    Spree::Country.find(Spree::Config[:default_country_id])
                                  else
                                    Spree::Country.find_by!(iso: 'US')
                                  end

      rescue ActiveRecord::RecordNotFound
        flash[:error] = Spree.t(:stock_locations_need_a_default_country)
        redirect_to(admin_stock_locations_path) && return
      end
    end
  end
end
