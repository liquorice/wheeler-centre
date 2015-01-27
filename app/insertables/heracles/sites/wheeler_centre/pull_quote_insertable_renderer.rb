module Heracles
  module Sites
    module WheelerCentre
      class PullQuoteInsertableRenderer < ::Heracles::InsertableRenderer
        include TextFormattingHelper
        ### Custom renderer

        def render
          # Return nothing if the asset is missing
          return "" unless data[:quote]

          super
        end

        ### Helpers

        def display_class
          "figure__display--#{(data[:display] || "default").downcase}"
        end
        helper_method :display_class
      end
    end
  end
end

