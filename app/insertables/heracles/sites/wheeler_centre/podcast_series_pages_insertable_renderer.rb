module Heracles
  module Sites
    module WheelerCentre
      class PodcastSeriesPagesInsertableRenderer < ::Heracles::PagesInsertableRenderer

        ### Helpers

        helper_method \
        def podcast_series
          pages
        end

        helper_method \
        def display_class
          case data[:display]
          when "Grid narrow"
            "figure__display--full-width"
          when "Grid mid"
            "figure__display--full-width"
          when "Grid wide"
            "figure__display--full-width"
          when "Right-aligned-narrow"
            "figure__display--right-aligned figure__display--right-aligned-narrow"
          else
            "figure__display--#{(data[:display].presence || "default").downcase}"
          end
        end

        helper_method \
        def column_class
          case data[:display]
          when "Grid narrow"
            "column-narrow"
          when "Grid mid"
            "column-mid"
          when "Grid wide"
            "column-wide"
          when "Full-width"
            "column-full"
          else
            "column-wide"
          end
        end

        helper_method \
        def grouper_config
          case data[:display]
          when "Grid narrow"
            { default: 3, phone: 2 }
          when "Grid mid"
            { default: 4, tablet: 3, "phone-wide" => 3, phone: 2 }
          when "Grid wide"
            { default: 4, "widescreen-wide" => 5, widescreen: 5, tablet: 3, "phone-wide" => 3, phone: 2 }
          when "Full-width"
            { default: 4, "widescreen-wide" => 6, widescreen: 5, tablet: 3, "phone-wide" => 3, phone: 2 }
          else
            { default: 4, "widescreen-wide" => 6, widescreen: 5, tablet: 3, "phone-wide" => 3, phone: 2 }
          end
        end

      end
    end
  end
end

