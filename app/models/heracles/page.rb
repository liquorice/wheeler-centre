require Heracles::Engine.root.join('app','models','heracles','page')

module Heracles
  class Page < ActiveRecord::Base
    def self.inherited(subclass)
      # Maintain the standard ActiveRecord behavior
      super

      # Define a search index directly on each page subclass
      subclass.class_eval do
        searchable auto_index: true, auto_remove: true do
          string :page_type

          text :title, boost: 2.0

          string :tags, multiple: true do
            tag_list.to_a
          end

          boolean :published
          boolean :hidden
          boolean :locked

          string :collection_id
          string :parent_id
          string :site_id

          time :created_at
          time :updated_at
        end
      end
    end
  end
end
