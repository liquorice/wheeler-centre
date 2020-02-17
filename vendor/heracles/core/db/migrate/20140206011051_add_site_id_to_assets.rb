class AddSiteIdToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :site_id, :uuid, null: false
    add_index :assets, :site_id
  end
end
