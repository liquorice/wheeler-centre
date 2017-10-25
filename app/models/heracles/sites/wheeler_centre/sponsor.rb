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
      end
    end
  end
end
