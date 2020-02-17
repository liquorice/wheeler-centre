class RenameSiteAdministrationsToHeraclesSiteAdministrations < ActiveRecord::Migration
  def change
    rename_table :site_administrations, :heracles_site_administrations
  end
end
