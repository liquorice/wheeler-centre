class AddSitesEdgeHostnames < ActiveRecord::Migration
  def change
    add_column :sites, :edge_hostnames, :string, array: true, default: []
    add_index :sites, :edge_hostnames
  end
end
