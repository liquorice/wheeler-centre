class AddHiddenToPages < ActiveRecord::Migration
  def change
    add_column :pages, :hidden, :boolean, default: false, null: false
    add_index :pages, :hidden
  end
end
