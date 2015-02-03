module Heracles
  module Sites
    module WheelerCentre
      class AudioInsertableRenderer < ::Heracles::AudioInsertableRenderer

        ### Helpers

        def display_class
          "figure__display--#{(data[:display] || "default").downcase}"
        end
        helper_method :display_class

      end
    end
  end
end

