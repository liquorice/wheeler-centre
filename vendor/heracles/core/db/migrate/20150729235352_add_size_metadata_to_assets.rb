class AddSizeMetadataToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :size, :integer
  end
end
