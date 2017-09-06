module Heracles
  module Sites
    module WheelerCentre
      class TickerAction < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :action_link, type: :text, label: "Ticker action link", editor_type: "code"}
            ]
          }
        end

        ### Summary

        def to_summary_hash
          {
            title: title,
            link: fields[:action_link],
            published: (published) ? "✔" : "•"
          }
        end
      end
    end
  end
end
