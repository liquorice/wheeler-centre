# This migration comes from heracles (originally 20150212013220)
class RenameSitesHostnamesToSitesOriginHostnames < ActiveRecord::Migration
  def change
    rename_column :sites, :hostnames, :origin_hostnames
  end
end
