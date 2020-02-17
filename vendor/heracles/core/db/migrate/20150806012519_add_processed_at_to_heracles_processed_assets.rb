class AddProcessedAtToHeraclesProcessedAssets < ActiveRecord::Migration
  def change
    add_column :heracles_processed_assets, :processed_at, :datetime
  end
end
