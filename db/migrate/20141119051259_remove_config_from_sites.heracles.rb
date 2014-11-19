# This migration comes from heracles (originally 20140116041331)
class RemoveConfigFromSites < ActiveRecord::Migration
  def change
    remove_column :sites, :config
  end
end
