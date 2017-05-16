# This migration comes from heracles (originally 20150728052819)
class AddContentTypeToAssets < ActiveRecord::Migration
  def up
    add_column :assets, :content_type, :string
    Heracles::Asset.find_each do |asset|
      asset.update_column(:content_type, asset.legacy_file_mime)
    end
    change_column_null :assets, :content_type, false
  end

  def down
    remove_column :assets, :content_type, :string
  end
end
