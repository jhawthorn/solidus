class UpdateProductSlugIndex < ActiveRecord::Migration
  def change
    safe_remove_index :spree_products, :slug
    safe_add_index :spree_products, :slug, unique: true
  end
end
