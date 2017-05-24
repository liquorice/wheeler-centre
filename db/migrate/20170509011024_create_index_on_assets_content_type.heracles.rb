# This migration comes from heracles (originally 20150805055409)
class CreateIndexOnAssetsContentType < ActiveRecord::Migration
  def up
    execute "CREATE INDEX index_assets_on_content_type ON assets (content_type varchar_pattern_ops)"
  end

  def down
    execute "DROP INDEX index_assets_on_content_type"
  end
end
