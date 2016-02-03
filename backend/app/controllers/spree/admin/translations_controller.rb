module Spree
  module Admin
    class TranslationsController < ActionController::Base
      skip_before_action :verify_authenticity_token
      layout false

      def show
        respond_to do |format|
          format.js
        end
      end
    end
  end
end
