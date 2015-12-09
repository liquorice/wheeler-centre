module Heracles
  module Sites
    module WheelerCentre
      class HomeQuote < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :person, type: :associated_pages, page_type: :person, editor_type: :singular},
              {name: :quote, type: :content, required: true, with_buttons: %i(bold italic), disable_insertables: true},
              {name: :caption, type: :content, required: true, with_buttons: %i(bold italic link), disable_insertables: true},
            ]
          }
        end

        ### Summary

        def to_summary_hash
          {
            person: (fields[:person].data_present?) ? fields[:person].pages.first.title : "None selected",
            quote: fields[:quote],
            published: (published) ? "✔" : "•",
            created_at:  created_at.to_s(:admin_date)
          }
        end
      end
    end
  end
end
