namespace :solidus do
  namespace :migrations do
    namespace :create_ledger_entries_for_store_credits do
      task up: :environment do
        print 'Creating opening ledger entries for store credits...'
        now = Time.current.to_s(:db)
        ActiveRecord::Base.connection.execute <<-SQL
        INSERT INTO spree_store_credit_ledger_entries
          (store_credit_id, amount, created_at, updated_at)
          SELECT id, amount - amount_used, '#{now}', '#{now}'
          FROM spree_store_credits
          WHERE invalidated_at IS NULL
        SQL
        ActiveRecord::Base.connection.execute <<-SQL
        INSERT INTO spree_store_credit_ledger_entries
          (store_credit_id, amount, created_at, updated_at)
          SELECT id, 0, '#{now}', '#{now}'
          FROM spree_store_credits
          WHERE invalidated_at IS NOT NULL
        SQL
        puts 'success'
      end

      task down: :environment do
        Spree::StoreCreditLedgerEntry.delete_all
      end
    end
  end
end
