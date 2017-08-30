module Heracles
  module Sites
    module WheelerCentre
      class TickerAction < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :button_name, type: :text, label: "Action name"},
              {name: :button_link, type: :text, label: "Action link", editor_type: "code"}
            ]
          }
        end
      end
    end
  end
end
