# This migration comes from heracles (originally 20131211053757)
class AddSuperadminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :superadmin, :boolean, null: false, default: false, after: :admin
  end
end
