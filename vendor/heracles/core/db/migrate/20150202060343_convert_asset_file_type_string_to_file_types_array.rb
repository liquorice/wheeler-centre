class ConvertAssetFileTypeStringToFileTypesArray < ActiveRecord::Migration
  def up
    add_column :assets, :file_types, :string, array: true, default: []
    add_index :assets, :file_types

    Heracles::Asset.reset_column_information
    Heracles::Asset.find_each do |asset|
      asset.update_column :file_types, [asset.file_type]
    end

    remove_column :assets, :file_type
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
