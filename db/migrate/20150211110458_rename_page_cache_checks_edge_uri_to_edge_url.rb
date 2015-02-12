class RenamePageCacheChecksEdgeUriToEdgeUrl < ActiveRecord::Migration
  def change
    rename_column :page_cache_checks, :edge_uri, :edge_url
  end
end
