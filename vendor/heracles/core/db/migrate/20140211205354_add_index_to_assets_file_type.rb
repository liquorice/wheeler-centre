class AddIndexToAssetsFileType < ActiveRecord::Migration
  def change
    add_index :assets, :file_type
  end
end
