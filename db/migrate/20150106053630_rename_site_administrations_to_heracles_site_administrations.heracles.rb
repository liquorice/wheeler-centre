# This migration comes from heracles (originally 20150106052321)
class RenameSiteAdministrationsToHeraclesSiteAdministrations < ActiveRecord::Migration
  def change
    rename_table :site_administrations, :heracles_site_administrations
  end
end
