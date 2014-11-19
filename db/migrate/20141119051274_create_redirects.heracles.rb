# This migration comes from heracles (originally 20140413000438)
class CreateRedirects < ActiveRecord::Migration
  def change
    create_table :redirects, id: :uuid do |t|
      t.uuid :site_id, null: false
      t.string :source_url, null: false
      t.string :target_url
      t.integer :redirect_order, null: false
      t.timestamps
    end

    add_index :redirects, :site_id
    add_index :redirects, [:site_id, :source_url]
  end
end
