class AddMetadataToAssets < ActiveRecord::Migration
  def change

    add_column :assets, :title, :string
    add_column :assets, :description, :text

  end
end
