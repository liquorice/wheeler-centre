class PrependLegacyToAssetFileTypes < ActiveRecord::Migration
  def up
    rename_column :assets, :file_types, :legacy_file_types
  end

  def down
    rename_column :assets, :legacy_file_types, :file_types
  end
end
