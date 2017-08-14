module Spree
  module Api
    class StockLocationsController < Spree::Api::BaseController
      def index
        authorize! :read, StockLocation

        @stock_locations = StockLocation.
          accessible_by(current_ability, :read).
          order('name ASC').
          ransack(params[:q]).
          result

        @stock_locations = paginate(@stock_locations)

        respond_with(@stock_locations)
      end

      def show
        respond_with(stock_location)
      end

      def create
        authorize! :create, StockLocation
        @stock_location = Spree::StockLocation.new(stock_location_params)
        if @stock_location.save
          render :show, status: 201
        else
          invalid_resource!(@stock_location)
        end
      end

      def update
        authorize! :update, stock_location
        if stock_location.update_attributes(stock_location_params)
          render :show, status: 200
        else
          invalid_resource!(stock_location)
        end
      end

      def destroy
        authorize! :destroy, stock_location
        stock_location.destroy
        render status: 204
      end

      private

      def stock_location
        @stock_location ||= Spree::StockLocation.accessible_by(current_ability, :read).find(params[:id])
      end

      def stock_location_params
        params.require(:stock_location).permit(permitted_stock_location_attributes)
      end
    end
  end
end
