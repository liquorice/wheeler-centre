class ChangeAssetsFileTypeToAllowNull < ActiveRecord::Migration
  def change
    change_column :assets, :file_type, :string, null: true
  end
end
