class AddAttributionMetadataToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :attribution, :string
  end
end
