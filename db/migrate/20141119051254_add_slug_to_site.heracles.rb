# This migration comes from heracles (originally 20131118033934)
class AddSlugToSite < ActiveRecord::Migration
  def change
    add_column :sites, :slug, :string
  end
end
