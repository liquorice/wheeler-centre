class AddBlueprintAttributesToHeraclesAssets < ActiveRecord::Migration
  def change
    add_column :assets, :blueprint_id, :integer
    add_column :assets, :blueprint_name, :string
    add_column :assets, :blueprint_filename, :string
    add_column :assets, :blueprint_attachable_type, :string
    add_column :assets, :blueprint_attachable_id, :integer
    add_column :assets, :blueprint_position, :integer
    add_column :assets, :blueprint_guid, :string
    add_column :assets, :blueprint_caption, :string
    add_column :assets, :blueprint_assoc, :string
  end
end
