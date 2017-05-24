# This migration comes from heracles (originally 20150728064055)
class AddOriginalPathAndOriginalPrefixToAssets < ActiveRecord::Migration
  def up
    add_column :assets, :original_path, :string

    Heracles::Asset.find_each do |asset|
      if asset['legacy_results'] && asset['legacy_results']['original']
        legacy_original_path = URI(asset['legacy_results']['original']['url']).path
        asset.update_column(:original_path, legacy_original_path.gsub(/^\//,''))
      end
    end

    # change_column_null :assets, :original_path, false

    # this column is removed in the next migration, 20151027031115
    add_column :assets, :original_prefix, :string
  end

  def down
    remove_column :assets, :original_path, :string
    remove_column :assets, :original_prefix, :string
  end
end
