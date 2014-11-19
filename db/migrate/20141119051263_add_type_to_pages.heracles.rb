# This migration comes from heracles (originally 20140122034516)
class AddTypeToPages < ActiveRecord::Migration
  def change
    add_column :pages, :type, :string
    add_index :pages, :type
  end
end
