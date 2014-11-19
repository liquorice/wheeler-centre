# This migration comes from heracles (originally 20140520034449)
class DropDeviseUsers < ActiveRecord::Migration
  def up
    drop_table :users
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
