module Heracles
  module Sites
    module WheelerCentre
      class LongformBlogEdition < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :summary, type: :content, hint: "Shown on the edition list page — can include image(s)"},
              {name: :intro, label: "Introduction", type: :content, hint: "Shown above the notes list"},
              {name: :subheading, type: :text, hint: "Heading above the notes list"},
              {name: :notes, type: :associated_pages, page_type: :longform_blog_post},
              {name: :end, type: :content, hint: "Shown after the notes list"},
            ]
          }
        end

        def posts(options={})
          fields[:notes].pages.page(options[:page_number] || 1).per(options[:per_page] || 1000)
        end
      end
    end
  end
end
