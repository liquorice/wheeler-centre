module Heracles
  module Sites
    module WheelerCentre
      class TickerText < ::Heracles::Page
        ### Summary

        def to_summary_hash
          {
            title: title,
            published: (published) ? "✔" : "•"
          }
        end
      end
    end
  end
end
