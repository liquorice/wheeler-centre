module Heracles
  module Sites
    module WheelerCentre
      class HomeBanner < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :label, type: :content, hint: "An (optional) short label for the banner", with_buttons: %i(bold italic), disable_insertables: true},
              {name: :banner_image, type: :assets, asset_file_type: :image, required: true},
              {name: :link, type: :text, editor_columns: 8, hint: "URL to link to. Ideally should start with a /, like /events/show-of-the-year", editor_type: :code, required: true},
              {name: :category, type: :text, editor_type: 'select', option_values: [ "Watch", "Listen", "Read", "Attend" ], editor_columns: 4},
            ]
          }
        end

        ### Summary

        def to_summary_hash
          {
            title: title,
            label: fields[:label],
            link: fields[:link],
            published: (published) ? "✔" : "•",
            created_at:  created_at.to_s(:admin_date)
          }
        end
      end
    end
  end
end
