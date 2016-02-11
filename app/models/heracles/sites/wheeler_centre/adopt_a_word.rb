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

          #children.of_type("campaign_word").published.order(:title)
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
          end
        end
      end
    end
  end
end
