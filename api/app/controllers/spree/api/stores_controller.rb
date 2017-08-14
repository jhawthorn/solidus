module Spree
  module Api
    class StoresController < Spree::Api::BaseController
      before_action :get_store, except: [:index, :create]

      def index
        authorize! :read, Store
        @stores = Spree::Store.accessible_by(current_ability, :read).all
        respond_with(@stores)
      end

      def create
        authorize! :create, Store
        @store = Spree::Store.new(store_params)
        @store.code = params[:store][:code]
        if @store.save
          render :show, status: 201
        else
          invalid_resource!(@store)
        end
      end

      def update
        authorize! :update, @store
        if @store.update_attributes(store_params)
          render :show, status: 200
        else
          invalid_resource!(@store)
        end
      end

      def show
        authorize! :read, @store
        respond_with(@store)
      end

      def destroy
        authorize! :destroy, @store
        @store.destroy
        respond_with(@store, status: 204)
      end

      private

      def get_store
        @store = Spree::Store.find(params[:id])
      end

      def store_params
        params.require(:store).permit(permitted_store_attributes)
      end
    end
  end
end
