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
              {name: :donation_intro, type: :content, disable_insertables: true},
              {name: :donation_info, type: :content, disable_insertables: true}
            ]
          }
        end

        ### Accessors
        def words
          children.of_type("campaign_word").published.order(:title)
        end

      end
    end
  end
end