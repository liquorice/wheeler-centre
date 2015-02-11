class RenamePageCacheCheckPathToEdgeUri < ActiveRecord::Migration
  def change
    rename_column :page_cache_checks, :path, :edge_uri
  end
end
