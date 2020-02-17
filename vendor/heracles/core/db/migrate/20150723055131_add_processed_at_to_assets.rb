class AddProcessedAtToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :processed_at, :datetime
  end
end
