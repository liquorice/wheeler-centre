# This migration comes from heracles (originally 20140219103633)
class AddCollectionIdToPages < ActiveRecord::Migration
  def change
    add_column :pages, :collection_id, :uuid
    add_index :pages, :collection_id
  end
end
