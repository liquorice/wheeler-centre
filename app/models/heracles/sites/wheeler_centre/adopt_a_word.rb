module Heracles
  module Sites
    module WheelerCentre
      class AdoptAWord < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :intro, type: :content},
              {name: :campaign_image, type: :asset, asset_file_type: :image},
              {name: :description_left, type: :content, disable_insertables: true},
              {name: :description_right, type: :content, disable_insertables: true},
              {name: :list_description, type: :text },
              {name: :donation_amount, type: :integer },
              {name: :donation_intro, type: :content, disable_insertables: true},
              {name: :donation_info, type: :content, disable_insertables: true},
              {name: :stories, type: :associated_pages, page_type: :blog_post}
            ]
          }
        end

        ### Accessors
        def words(options={})
          search_words(options)
        end

        def recent_adopted_words(options={})
          search_recent_words(options)
        end

        def stories
          if fields[:stories].data_present?
            fields[:stories].pages.visible.published.first(2)
          end
        end

        def word_page(word)
          find_word(word.downcase.strip).results.first
        end

        private

        def search_words(options={})
          Sunspot.search(CampaignWord) do
            with :site_id, site.id
            with :parent_id, id
            with :published, true
            with :hidden, false
            with :available, true

            order_by :title, :asc
            paginate(page: options[:page] || 1, per_page: options[:per_page] || 1000)
          end
        end

        def find_word(word)
          Sunspot.search(CampaignWord) do
            with :site_id, site.id
            with :parent_id, id
            with :published, true
            with :title, word
          end
        end

        def search_recent_words(options={})
          Sunspot.search(CampaignWord) do
            with :site_id, site.id
            with :parent_id, id
            with :published, true
            with :hidden, false
            with :available, false

            order_by :updated_at, :desc
            paginate(page: options[:page] || 1, per_page: options[:per_page] || 8)
          end
        end
      end
    end
  end
end
