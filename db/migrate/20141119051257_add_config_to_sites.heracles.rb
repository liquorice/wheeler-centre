# This migration comes from heracles (originally 20131211000123)
class AddConfigToSites < ActiveRecord::Migration
  def change
    add_column :sites, :config, :text, null: false, default: ""
  end
end
