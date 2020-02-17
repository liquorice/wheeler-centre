class AddOriginalPathAndOriginalPrefixToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :original_path, :string, null: false
    add_column :assets, :original_prefix, :string, null: false
  end
end
