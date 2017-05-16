# This migration comes from heracles (originally 20150723045828)
class CreateHeraclesProcessedAssets < ActiveRecord::Migration
  def change
    create_table :heracles_processed_assets do |t|
      t.uuid :asset_id, null: false
      t.string :processor, null: false
      t.json :data
      t.timestamps
    end

    add_index :heracles_processed_assets, :asset_id
    add_index :heracles_processed_assets, :processor
  end
end
