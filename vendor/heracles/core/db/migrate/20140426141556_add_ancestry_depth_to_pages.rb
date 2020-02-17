class AddAncestryDepthToPages < ActiveRecord::Migration
  def up
    add_column :pages, :ancestry_depth, :integer, default: 0
    Heracles::Page.rebuild_depth_cache!
  end

  def down
    remove_column :pages, :ancestry_depth
  end
end
