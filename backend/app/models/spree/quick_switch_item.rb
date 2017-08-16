module Spree
  class QuickSwitchItem
    attr_reader :search_terms, :method, :help_text

    # @param search_terms [Array<Symbol>] The search terms (keys)
    # @param method [Symbol] The method to be invoked if the search terms match
    # @param help_text [String] A helpful guide for admins to understand how to
    #   use this QuickSwitchItem
    #
    # @example
    #   Spree::QuickSwitchItem.new(
    #     [:o, :order],
    #     :find_and_redirect_to_order,
    #     "o ORDER_NUMBER"
    #   )
    def initialize(search_terms, method, help_text)
      @search_terms = search_terms
      @method = method
      @help_text = help_text
    end
  end
end
