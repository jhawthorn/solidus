# Financial transaction entry for a specific `store_credit`
module Spree
  class StoreCreditLedgerEntry < Spree::Base
    belongs_to :store_credit
    belongs_to :originator, polymorphic: true

    scope :chronological, -> { order(:created_at) }
    scope :reverse_chronological, -> { order(created_at: :desc) }

    delegate :currency, to: :store_credit

    class << self
      # for store_credit created before the introduction of
      # the ledger entries
      def generate_opening_ledger_entry_for(store_credit)
        store_credit.store_credit_ledger_entries.create!({
          amount: store_credit.amount - store_credit.amound_used
        })
      end
    end
  end
end
