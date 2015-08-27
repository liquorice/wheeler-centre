class ChangeHeraclesAssetsFileSizeToBigint < ActiveRecord::Migration
  def change
    change_column :assets, :file_size, :bigint, null: false
  end
end
