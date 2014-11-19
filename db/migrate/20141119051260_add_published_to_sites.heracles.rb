# This migration comes from heracles (originally 20140116054825)
class AddPublishedToSites < ActiveRecord::Migration
  def change
    add_column :sites, :published, :boolean, default: false
    add_index :sites, :published
  end
end
