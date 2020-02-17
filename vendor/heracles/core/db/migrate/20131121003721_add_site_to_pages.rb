class AddSiteToPages < ActiveRecord::Migration
  def change
    add_column :pages, :site_id, :uuid, null: false
    add_index :pages, :site_id
  end
end
