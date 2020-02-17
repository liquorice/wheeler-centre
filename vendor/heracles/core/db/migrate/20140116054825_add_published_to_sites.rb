class AddPublishedToSites < ActiveRecord::Migration
  def change
    add_column :sites, :published, :boolean, default: false
    add_index :sites, :published
  end
end
