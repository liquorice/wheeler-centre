class AddTransloaditParamsToSites < ActiveRecord::Migration
  def change
    add_column :sites, :transloadit_params, :json, default: {}, null: false
  end
end
