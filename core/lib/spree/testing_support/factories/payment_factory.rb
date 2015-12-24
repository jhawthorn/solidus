FactoryGirl.define do
  factory :base_payment, class: Spree::Payment do
    transient do
      address nil # used on a credit card source
    end
  end
  factory :payment, aliases: [:credit_card_payment], parent: :base_payment do
    association(:payment_method, factory: :credit_card_payment_method)
    source do |e|
      e.association(:credit_card, address: e.address)
    end
    order
    state 'checkout'
    response_code '12345'

    factory :payment_with_refund do
      transient do
        refund_amount 5
      end

      state 'completed'

      refunds { build_list :refund, 1, amount: refund_amount }
    end
  end

  factory :check_payment, class: Spree::Payment, parent: :base_payment do
    association(:payment_method, factory: :check_payment_method)
    order
  end

  factory :store_credit_payment, class: Spree::Payment, parent: :payment do
    association(:payment_method, factory: :store_credit_payment_method)
    association(:source, factory: :store_credit)
  end
end
