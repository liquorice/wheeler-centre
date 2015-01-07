# This migration comes from heracles (originally 20141015044644)
class AddAttributionMetadataToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :attribution, :string
  end
end
