class CreateHeraclesAssets < ActiveRecord::Migration
  def change
    create_table :assets, id: :uuid do |t|
      # Original file data
      t.string :file_name, null: false
      t.string :file_basename, null: false
      t.string :file_ext, null: false
      t.integer :file_size, null: false
      t.string :file_mime, null: false
      t.string :file_type, null: false

      # Assembly data
      t.string :assembly_id, null: false
      t.string :assembly_url, null: false
      t.float :upload_duration
      t.float :execution_duration
      t.string :assembly_message

      # Original file metadata
      t.json :file_meta, default: {}, null: false

      # Assembly results (stored file versions, thumbnails, etc.)
      t.json :results, default: {}, null: false

      t.timestamps
    end
  end
end
