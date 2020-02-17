class AddPublishedToPages < ActiveRecord::Migration
  def change
    add_column :pages, :published, :boolean, default: false, null: false
    add_index :pages, :published
  end
end
