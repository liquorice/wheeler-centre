class AddRecordingIdToAssets < ActiveRecord::Migration
  def change
  	add_column :assets, :recording_id, :integer
  end
end
