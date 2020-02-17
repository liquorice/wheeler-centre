class AddUrlToPages < ActiveRecord::Migration
  def change
    add_column :pages, :url, :text
    add_index :pages, :url
  end
end
