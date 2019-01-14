module Heracles
  module Sites
    module WheelerCentre
      class Sponsor < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :body, type: :content},
              {name: :url, type: :text, label: "URL"},
              {name: :logo, type: :assets, assets_file_type: :image},
              {name: :sponsor_id, type: :integer, label: "Sponsor Id"},
            ]
          }
        end

        def csv_headers
          [
            "ID",
            "Title",
            "URL",
            "Body",
            "Sponsor URL",
            "Logo",
            "Sponsor ID",
            "Updated at",
            "Created at",
          ]
        end

        def to_csv
          [
            id,
            title,
            absolute_url,
            fields[:body],
            fields[:url],
            (fields[:logo].assets.first.original_url if fields[:logo].data_present?),
            fields[:sponsor_id],
            updated_at,
            created_at,
          ]
        end
      end
    end
  end
end
