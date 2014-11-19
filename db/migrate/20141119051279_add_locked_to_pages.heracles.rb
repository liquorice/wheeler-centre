# This migration comes from heracles (originally 20140421062303)
class AddLockedToPages < ActiveRecord::Migration
  def change
    add_column :pages, :locked, :boolean, default: false, null: false
  end
end
