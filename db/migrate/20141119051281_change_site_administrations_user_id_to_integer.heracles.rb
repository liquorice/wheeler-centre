# This migration comes from heracles (originally 20140519234051)
class ChangeSiteAdministrationsUserIdToInteger < ActiveRecord::Migration

  # This migration is a hack: it removes the column and re-adds it, just to
  # avoid having to do type conversion. Before Heracles is used again, we should
  # flatten down all the migraitons into simple "create_table" ones.

  def up
    remove_column :site_administrations, :user_id
    add_column :site_administrations, :user_id, :integer, null: false
    add_index :site_administrations, :user_id
  end

  def down
    remove_column :site_administrations, :user_id
    add_column :site_administrations, :user_id, :uuid, null: false
    add_index :site_administrations, :user_id
  end
end
