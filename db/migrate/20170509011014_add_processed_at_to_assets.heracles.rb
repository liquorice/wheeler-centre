# This migration comes from heracles (originally 20150723055131)
class AddProcessedAtToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :processed_at, :datetime
  end
end
