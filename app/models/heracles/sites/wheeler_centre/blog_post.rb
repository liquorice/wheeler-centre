module Heracles
  module Sites
    module WheelerCentre
      class BlogPost < Heracles::Page

        ### Page config

        def self.config
          {
            fields: [
              {name: :publish_at, type: :date_time, show_in_index: true},
              {name: :body, label: "Main content", type: :content, hint: "Main body content", editor_columns: 12},
            ]
          }
        end

        searchable do
          text :body do
            fields[:body].value
          end

          time :publish_at do
            fields[:publish_at].value
          end
        end

      end
    end
  end
end
