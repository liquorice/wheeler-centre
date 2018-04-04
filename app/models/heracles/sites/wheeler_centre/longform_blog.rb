module Heracles
  module Sites
    module WheelerCentre
      class LongformBlog < Heracles::Page
        def self.config
          {
            fields: [
              {name: :intro, label: "Introduction", type: :content},
              {name: :end, type: :content, hint: "Sits after the edition list"},
            ]
          }
        end

        def editions(options={})
          search_editions(options)
        end

        private

        def search_editions(options={})
          # active = options[:active]
          # EventSeries.where("fields_data->'archived'->>'value' != ?", "#{active}")
          LongformBlogEdition
            .published
            .visible
            .order(:title)
            # .page(1)
            # .per(1000)
            # .select{ |res| res.events.present? }
        end
      end
    end
  end
end
