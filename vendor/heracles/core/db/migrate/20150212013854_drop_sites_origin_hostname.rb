class DropSitesOriginHostname < ActiveRecord::Migration
  def up
    remove_column :sites, :origin_hostname
  end

  def down
    add_column :sites, :origin_hostname, :string
  end
end
