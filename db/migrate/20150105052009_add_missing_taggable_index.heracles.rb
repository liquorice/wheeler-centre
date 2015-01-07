# This migration comes from heracles (originally 20140922075051)
class AddMissingTaggableIndex < ActiveRecord::Migration

  def self.up
    add_index :taggings, [:taggable_id, :taggable_type, :context]
  end

  def self.down
    remove_index :taggings, [:taggable_id, :taggable_type, :context]
  end

end
