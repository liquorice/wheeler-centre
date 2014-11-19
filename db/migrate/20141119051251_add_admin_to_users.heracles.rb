# This migration comes from heracles (originally 20131111011330)
class AddAdminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean, null: false, default: false
  end
end
