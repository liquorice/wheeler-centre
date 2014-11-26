module Heracles
  module Sites
    module WheelerCentre
      class BlogPost < Heracles::Page

        ### Page config

        def self.config
          {
            fields: [
              {name: :body, label: "Main content", type: :content, hint: "Main body content", editor_columns: 12},
            ]
          }
        end

        searchable do
          text :body do
            fields[:body].value
          end
        end

      end
    end
  end
end
