# This migration comes from heracles (originally 20150729235352)
class AddSizeMetadataToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :size, :bigint
  end
end
