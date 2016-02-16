module Heracles
  module Sites
    module WheelerCentre
      class AdoptAWordArchive < ::Heracles::Page
        include ApplicationHelper

        def self.config
          {
            fields: [
              {name: :intro, type: :content},
            ]
          }
        end

        def words(options={})
          search_words(options)
        end

        private

        def words_index
          parent
        end

        def search_words(options={})
          Sunspot.search(CampaignWord) do
            with :site_id, site.id
            with :parent_id, words_index.id
            with :published, true
            with :hidden, false
            with :available, false

            order_by :title, :asc
          end
        end
      end
    end
  end
end
