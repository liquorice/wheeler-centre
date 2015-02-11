# This migration comes from heracles (originally 20150211010614)
class AddOriginHostnameToSites < ActiveRecord::Migration
  def change
    add_column :sites, :origin_hostname, :string
  end
end
