module Spree
  module Admin
    class QuickSwitchController < Spree::Admin::BaseController
      layout false

      def find_object
        case searched_key
        when "o"
          find_and_redirect_to_order
        when "p"
          find_and_redirect_to_variant
        when "s"
          find_and_redirect_to_shipment
        when "u"
          find_and_redirect_to_user
        when "v"
          find_and_redirect_to_variant
        else
          message = Spree.t("quick_switch.invalid_query")
          respond_to do |format|
            format.html { redirect_back(fallback_location: spree.admin_path, flash: { error: message }) }
            format.json { render json: { message: message }, status: :bad_request }
          end
        end
      end

      private

      def redirect_to_url(url)
        respond_to do |format|
          format.html { redirect_to url }
          format.json { render json: { redirect_url: url }, status: :ok }
        end
      end

      def not_found(message)
        respond_to do |format|
          format.html { redirect_back(fallback_location: spree.admin_path, flash: { error: message }) }
          format.json { render json: { message: message }, status: :not_found }
        end
      end

      def searched_key
        params[:quick_switch_query].split(" ")[0]
      end

      def searched_value
        params[:quick_switch_query].split(" ")[1]
      end

      def find_and_redirect_to_order
        if order = Spree::Order.find_by(number: searched_value)
          redirect_to_url spree.edit_admin_order_path(order)
        else
          not_found(
            Spree.t("quick_switch.order_not_found", value: searched_value)
          )
        end
      end

      def find_and_redirect_to_shipment
        if shipment = Spree::Shipment.find_by(number: searched_value)
          redirect_to_url spree.edit_admin_order_path(shipment.order)
        else
          not_found(
            Spree.t("quick_switch.shipment_not_found", value: searched_value)
          )
        end
      end

      def find_and_redirect_to_user
        if user = Spree.user_class.find_by(email: searched_value)
          redirect_to_url spree.edit_admin_user_path(user)
        else
          not_found(
            Spree.t("quick_switch.user_not_found", value: searched_value)
          )
        end
      end

      def find_and_redirect_to_variant
        if variant = Spree::Variant.find_by(sku: searched_value)
          if variant.is_master?
            redirect_to_url spree.edit_admin_product_path(variant.product)
          else
            redirect_to_url spree.edit_admin_product_variant_path(
              variant.product,
              variant
            )
          end
        else
          not_found(
            Spree.t("quick_switch.variant_not_found", value: searched_value)
          )
        end
      end
    end
  end
end
