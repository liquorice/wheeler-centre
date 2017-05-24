module Heracles
  module Sites
    module WheelerCentre
      class CampaignWord < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :definition, type: :text},
              {name: :is_available, type: :boolean, defaults: {value: true}, question_text: "Available for purchase?"},
              {name: :thankyou_image, type: :assets, asset_file_type: :image }
            ]
          }
        end

        ### Summary

        def to_summary_hash
          {
            word: title,
            available: fields[:is_available],
            published: (published) ? "✔" : "•",
            created_at:  created_at.to_s(:admin_date)
          }
        end

        ### Searchable attrs

        searchable do
          # From old Heracles core
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
          # From old Heracles core

          string :title do
            title.downcase.strip
          end

          boolean :available do
            fields[:is_available].value
          end
        end
      end


    end
  end
end
