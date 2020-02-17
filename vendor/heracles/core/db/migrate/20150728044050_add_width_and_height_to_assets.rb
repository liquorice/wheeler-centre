class AddWidthAndHeightToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :width, :integer
    add_column :assets, :height, :integer
  end
end
