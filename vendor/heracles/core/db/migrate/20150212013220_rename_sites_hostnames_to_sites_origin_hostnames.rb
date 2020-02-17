class RenameSitesHostnamesToSitesOriginHostnames < ActiveRecord::Migration
  def change
    rename_column :sites, :hostnames, :origin_hostnames
  end
end
