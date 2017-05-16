# This migration comes from heracles (originally 20150729050153)
class AddRawAndCorrectedMetadataToAssets < ActiveRecord::Migration
  def change
    rename_column :assets, :height, :raw_height
    rename_column :assets, :width, :raw_width
    add_column :assets, :raw_orientation, :bigint
    add_column :assets, :corrected_height, :bigint
    add_column :assets, :corrected_width, :bigint
    add_column :assets, :corrected_orientation, :string
  end
end
