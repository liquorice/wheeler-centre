# This migration comes from heracles (originally 20140627075318)
class ChangeAssetsFileTypeToAllowNull < ActiveRecord::Migration
  def change
    change_column :assets, :file_type, :string, null: true
  end
end
