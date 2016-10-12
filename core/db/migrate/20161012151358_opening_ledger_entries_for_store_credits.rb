class OpeningLedgerEntriesForStoreCredits < ActiveRecord::Migration[5.0]
  # Prevent everything from running in one giant transaction in postrgres.
  disable_ddl_transaction!

  def up
    Rake::Task["spree:migrations:create_ledger_entries_for_store_credits:up"].invoke
  end

  def down
    Rake::Task["spree:migrations:create_ledger_entries_for_store_credits:down"].invoke
  end
end
