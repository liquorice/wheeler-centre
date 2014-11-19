# This migration comes from heracles (originally 20140415053039)
class AddNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
  end
end
