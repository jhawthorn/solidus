namespace :solidus do
  namespace :migrations do
    namespace :create_ledger_entries_for_store_credits do
      task up: :environment do
        print 'Creating opening ledger entries for store credits...'
        Spree::StoreCredit.find_each do |store_credit|
          current_balance_amount = store_credit.amount_remaining + store_credit.amount_authorized
          current_balance_amount = 0 if current_balance_amount < 0
          store_credit.store_credit_ledger_entries.create!({
            amount: current_balance_amount
          })
        end
        puts ' success'
      end

      task down: :environment do
        Spree::StoreCreditLedgerEntry.delete_all
      end
    end
  end
end
