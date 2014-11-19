# This migration comes from heracles (originally 20140120225804)
class AddAncestryToPages < ActiveRecord::Migration
  def change
    add_column :pages, :ancestry, :string
    add_index :pages, :ancestry
  end
end
