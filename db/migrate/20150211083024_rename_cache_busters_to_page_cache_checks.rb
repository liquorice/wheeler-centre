class RenameCacheBustersToPageCacheChecks < ActiveRecord::Migration
  def change
    rename_table :cache_busters, :page_cache_checks
  end
end
