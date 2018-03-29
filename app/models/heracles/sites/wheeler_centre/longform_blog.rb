module Heracles
  module Sites
    module WheelerCentre
      class LongformBlog < Heracles::Page
        def self.config
          {
            fields: [
              {name: :intro, label: "Introduction", type: :content},
              {name: :highlighted_authors_title, type: :text},
              {name: :highlighted_authors_intro, type: :content, with_buttons: %i(bold italic link), disable_insertables: true},
              {name: :highlighted_authors, type: :associated_pages, page_type: :person},
              {name: :middle, type: :content, hint: "Sits between 'Latest' and 'Guest posts'"},
              {name: :end, type: :content, hint: "Sits after 'Guest posts'"},
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
