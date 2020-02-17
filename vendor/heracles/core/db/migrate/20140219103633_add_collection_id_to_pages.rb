class AddCollectionIdToPages < ActiveRecord::Migration
  def change
    add_column :pages, :collection_id, :uuid
    add_index :pages, :collection_id
  end
end
