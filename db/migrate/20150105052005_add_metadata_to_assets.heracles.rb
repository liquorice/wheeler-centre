# This migration comes from heracles (originally 20140915070258)
class AddMetadataToAssets < ActiveRecord::Migration
  def change

    add_column :assets, :title, :string
    add_column :assets, :description, :text

  end
end
