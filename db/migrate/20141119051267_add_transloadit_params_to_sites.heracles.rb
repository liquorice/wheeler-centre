# This migration comes from heracles (originally 20140206060456)
class AddTransloaditParamsToSites < ActiveRecord::Migration
  def change
    add_column :sites, :transloadit_params, :json, default: {}, null: false
  end
end
