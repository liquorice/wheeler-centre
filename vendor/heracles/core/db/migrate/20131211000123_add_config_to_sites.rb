class AddConfigToSites < ActiveRecord::Migration
  def change
    add_column :sites, :config, :text, null: false, default: ""
  end
end
