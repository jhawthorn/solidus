module Spree
  module Api
    class TransferItemsController < Spree::Api::BaseController
      def index
        authorize! :index, TransferItem
        stock_transfer = StockTransfer.accessible_by(current_ability, :show).find_by(number: params[:stock_transfer_id])
        @transfer_items = stock_transfer.transfer_items
        respond_with(@transfer_items, default_template: :index)
      end

      def create
        authorize! :create, TransferItem
        stock_transfer = StockTransfer.accessible_by(current_ability, :update).find_by(number: params[:stock_transfer_id])
        @transfer_item = stock_transfer.transfer_items.build(transfer_item_params)
        if @transfer_item.save
          respond_with(@transfer_item, status: 201, default_template: :show)
        else
          invalid_resource!(@transfer_item)
        end
      end

      def update
        authorize! :update, TransferItem
        @transfer_item = TransferItem.accessible_by(current_ability, :update).find(params[:id])
        if @transfer_item.update_attributes(transfer_item_params)
          respond_with(@transfer_item, status: 200, default_template: :show)
        else
          invalid_resource!(@transfer_item)
        end
      end

      def destroy
        authorize! :destroy, TransferItem
        @transfer_item = TransferItem.accessible_by(current_ability, :destroy).find(params[:id])
        if @transfer_item.destroy
          respond_with(@transfer_item, status: 200, default_template: :show)
        else
          invalid_resource!(@transfer_item)
        end
      end

      private

      def transfer_item_params
        params.require(:transfer_item).permit(permitted_transfer_item_attributes)
      end
    end
  end
end
