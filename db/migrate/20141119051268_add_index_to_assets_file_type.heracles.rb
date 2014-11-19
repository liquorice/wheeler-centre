# This migration comes from heracles (originally 20140211205354)
class AddIndexToAssetsFileType < ActiveRecord::Migration
  def change
    add_index :assets, :file_type
  end
end
