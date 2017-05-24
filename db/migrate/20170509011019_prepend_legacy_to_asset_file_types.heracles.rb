# This migration comes from heracles (originally 20150728055533)
class PrependLegacyToAssetFileTypes < ActiveRecord::Migration
  def up
    # rename_column :assets, :file_size, :legacy_file_size
    # rename_column :assets, :file_mime, :legacy_file_mime
    # rename_column :assets, :assembly_id, :legacy_assembly_id
    # rename_column :assets, :assembly_url, :legacy_assembly_url
    # rename_column :assets, :upload_duration, :legacy_upload_duration
    # rename_column :assets, :execution_duration, :legacy_execution_duration
    # rename_column :assets, :assembly_message, :legacy_assembly_message
    # rename_column :assets, :file_meta, :legacy_file_meta
    # rename_column :assets, :results, :legacy_results

    change_column :assets, :legacy_file_size, :bigint, null: true
    change_column :assets, :legacy_file_mime, :string, null: true
    change_column :assets, :legacy_assembly_id, :string, null: true
    change_column :assets, :legacy_assembly_url, :string, null: true
    change_column :assets, :legacy_file_meta, :json, default: {}, null: true
    change_column :assets, :legacy_results, :json, default: {}, null: true
  end

  def down
    rename_column :assets, :legacy_file_size, :file_size
    rename_column :assets, :legacy_file_mime, :file_mime
    rename_column :assets, :legacy_assembly_id, :assembly_id
    rename_column :assets, :legacy_assembly_url, :assembly_url
    rename_column :assets, :legacy_upload_duration, :upload_duration
    rename_column :assets, :legacy_execution_duration, :execution_duration
    rename_column :assets, :legacy_assembly_message, :assembly_message
    rename_column :assets, :legacy_file_meta, :file_meta
    rename_column :assets, :legacy_results, :results
  end
end
