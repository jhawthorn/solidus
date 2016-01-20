module Spree
  module Admin
    class StoreCreditsController < ResourceController
      belongs_to 'spree/user', model_class: Spree.user_class
      before_action :load_categories, only: [:new]
      before_action :load_update_reasons, only: [:edit_amount, :edit_validity]
      before_action :ensure_update_reason, only: [:update_amount, :invalidate]

      helper Spree::Admin::StoreCreditEventsHelper

      def show
        @store_credit_events = @store_credit.store_credit_events.chronological
      end

      def create
        @store_credit = @user.store_credits.build(
          permitted_resource_params.merge({
                                            created_by: try_spree_current_user,
                                            action_originator: try_spree_current_user
                                          })
        )

        if @store_credit.save
          flash[:success] = flash_message_for(@store_credit, :successfully_created)
          redirect_to admin_user_store_credits_path(@user)
        else
          load_categories
          flash[:error] = "#{Spree.t('admin.store_credits.unable_to_create')} #{@store_credit.errors.full_messages}"
          render :new
        end
      end

      def update
        @store_credit.assign_attributes(permitted_resource_params)
        @store_credit.created_by = try_spree_current_user

        if @store_credit.save
          respond_to do |format|
            format.json { render json: { message: flash_message_for(@store_credit, :successfully_updated) }, status: :ok }
          end
        else
          respond_to do |format|
            format.json { render json: { message: "#{Spree.t('admin.store_credits.unable_to_update')} #{@store_credit.errors.full_messages}" }, status: :bad_request }
          end
        end
      end

      def update_amount
        @store_credit = @user.store_credits.find(params[:id])
        amount = params.require(:store_credit).require(:amount)
        if @store_credit.update_amount(amount, @update_reason, try_spree_current_user)
          flash[:success] = flash_message_for(@store_credit, :successfully_updated)
          redirect_to admin_user_store_credit_path(@user, @store_credit)
        else
          render_edit_page
        end
      end

      def invalidate
        @store_credit = @user.store_credits.find(params[:id])
        if @store_credit.invalidate(@update_reason, try_spree_current_user)
          redirect_to admin_user_store_credit_path(@user, @store_credit)
        else
          render_edit_page
        end
      end

      private

      def permitted_resource_params
        params.require(:store_credit).permit([:amount, :category_id, :memo]).
          merge(currency: Spree::Config[:currency], created_by: try_spree_current_user)
      end

      def collection
        @collection = super.reverse_order
      end

      def load_update_reasons
        @update_reasons = Spree::StoreCreditUpdateReason.all.order(:name)
      end

      def load_categories
        @credit_categories = Spree::StoreCreditCategory.all.order(:name)
      end

      def ensure_update_reason
        @update_reason = Spree::StoreCreditUpdateReason.find_by(id: params[:update_reason_id])
        unless @update_reason
          @store_credit.errors.add(:base, Spree.t("admin.store_credits.errors.update_reason_required"))
          render_edit_page
        end
      end

      def render_edit_page
        if action == :update_amount
          template = :edit_amount
          translation_key = 'update'
        else
          template = :edit_validity
          translation_key = 'invalidate'
        end

        load_update_reasons
        flash[:error] = "#{Spree.t("admin.store_credits.unable_to_#{translation_key}")}: #{@store_credit.errors.full_messages.join(', ')}"
        render(template) && return
      end
    end
  end
end
