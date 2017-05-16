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
          CampaignWord.where(
            site_id: site.id,
            published: true,
            hidden: false,
          )
          .order(:title)
          .where("fields_data->'is_available'->>'value' = ?", 'false')
          .children_of(AdoptAWord.find(words_index.id))
          .page(options[:page] || 1)
          .per(options[:per_page] || 1000)
          # Sunspot.search(CampaignWord) do
          #   with :site_id, site.id
          #   with :parent_id, words_index.id
          #   with :published, true
          #   with :hidden, false
          #   with :available, false

          #   order_by :title, :asc
          #   paginate(page: options[:page] || 1, per_page: options[:per_page] || 1000)
          # end
        end
      end
    end
  end
end
