require 'csv'

module Spree
  module Admin
    class PromotionCodesController < Spree::Admin::ResourceController
      before_action :load_promotion
      def index
        @promotion_codes = @promotion.promotion_codes

        respond_to do |format|
          format.html do
            @promotion_codes = @promotion_codes.page(params[:page]).per(50)
          end
          format.csv do
            filename = "promotion-code-list-#{@promotion.id}.csv"
            headers["Content-Type"] = "text/csv"
            headers["Content-disposition"] = "attachment; filename=\"#{filename}\""
          end
        end
      end

      private

      def load_promotion
        @promotion = Spree::Promotion.accessible_by(current_ability, :read).find(params[:promotion_id])
      end
    end
  end
end
