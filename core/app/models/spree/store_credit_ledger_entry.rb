# Financial transaction entry for a specific `store_credit`
module Spree
  class StoreCreditLedgerEntry < Spree::Base
    belongs_to :store_credit
    belongs_to :originator, polymorphic: true

    scope :chronological, -> { order(:created_at) }
    scope :reverse_chronological, -> { order(created_at: :desc) }

    delegate :currency, to: :store_credit
  end
end
