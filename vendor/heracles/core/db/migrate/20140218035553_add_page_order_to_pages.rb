class AddPageOrderToPages < ActiveRecord::Migration
  def change
    add_column :pages, :page_order, :integer, null: false
  end
end
