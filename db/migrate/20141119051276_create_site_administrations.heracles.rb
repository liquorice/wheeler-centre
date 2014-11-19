# This migration comes from heracles (originally 20140414061906)
class CreateSiteAdministrations < ActiveRecord::Migration
  def change
    create_table :site_administrations, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.uuid :site_id, null: false
      t.timestamps
    end

    add_index :site_administrations, :user_id
    add_index :site_administrations, :site_id
  end
end
