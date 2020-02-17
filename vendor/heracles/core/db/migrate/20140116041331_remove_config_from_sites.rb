class RemoveConfigFromSites < ActiveRecord::Migration
  def change
    remove_column :sites, :config
  end
end
