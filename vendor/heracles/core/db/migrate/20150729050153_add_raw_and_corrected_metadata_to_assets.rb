class AddRawAndCorrectedMetadataToAssets < ActiveRecord::Migration
  def change
    rename_column :assets, :height, :raw_height
    rename_column :assets, :width, :raw_width
    add_column :assets, :raw_orientation, :integer
    add_column :assets, :corrected_height, :integer
    add_column :assets, :corrected_width, :integer
    add_column :assets, :corrected_orientation, :string
  end
end
