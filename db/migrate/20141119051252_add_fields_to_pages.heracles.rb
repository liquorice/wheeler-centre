# This migration comes from heracles (originally 20131111034126)
class AddFieldsToPages < ActiveRecord::Migration
  def change
    change_table :pages do |t|
      t.column :title, :string, null: false
      t.column :fields_data, :json, null: false, default: {}
    end
  end
end
