class PrependLegacyToAssetFileBasenameAndFileExt < ActiveRecord::Migration
  def up
    rename_column :assets, :file_basename, :legacy_file_basename
    rename_column :assets, :file_ext, :legacy_file_ext

    change_column :assets, :legacy_file_basename, :string, null: true
    change_column :assets, :legacy_file_ext, :string, null: true
  end

  def down
    rename_column :assets, :legacy_file_basename, :file_basename
    rename_column :assets, :legacy_file_ext, :file_ext
  end
end
