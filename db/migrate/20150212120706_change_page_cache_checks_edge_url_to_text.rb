class ChangePageCacheChecksEdgeUrlToText < ActiveRecord::Migration
  def change
    change_column :page_cache_checks, :edge_url, :text, null: false
  end
end
