module Spree
  module MigrationHelpers
    def safe_remove_index(table, column)
      remove_index(table, column) if index_exists?(table, column)
    end

    def safe_add_index(table, column, options={})
      if column_exists?(table, column) && !index_exists?(table, column, options)
        add_index(table, column, options)
      end
    end
  end
end
