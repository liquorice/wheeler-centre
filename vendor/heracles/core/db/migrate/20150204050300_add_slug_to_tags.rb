class AddSlugToTags < ActiveRecord::Migration
  def up
    add_column :tags, :slug, :string

    ActsAsTaggableOn::Tag.find_each do |tag|
      tag.send :set_slug
      tag.update_column :slug, tag.slug
    end

    change_column :tags, :slug, :string, null: false, uniq: true
    add_index :tags, :slug
  end

  def down
    remove_column :tags, :slug
  end
end
