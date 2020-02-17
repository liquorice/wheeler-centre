class AddOriginHostnameToSites < ActiveRecord::Migration
  def change
    add_column :sites, :origin_hostname, :string
  end
end
