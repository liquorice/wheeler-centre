# This migration comes from heracles (originally 20140922074956)
require "acts-as-taggable-on"

class AddTaggingsCounterCacheToTags < ActiveRecord::Migration

   def self.up
    add_column :tags, :taggings_count, :integer, default: 0

    ActsAsTaggableOn::Tag.reset_column_information
    ActsAsTaggableOn::Tag.find_each do |tag|
      ActsAsTaggableOn::Tag.reset_counters(tag.id, :taggings)
    end
  end

  def self.down
    remove_column :tags, :taggings_count
  end

end
