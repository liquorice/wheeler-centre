module Heracles
  module Sites
    module WheelerCentre
      class CampaignWord < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :definition, type: :text},
              {name: :is_available, type: :boolean, defaults: {value: true}, question_text: "Available for purchase?"}
            ]
          }
        end

        ### Summary

        def to_summary_hash
          {
            word: title,
            available: fields[:is_available],
            published: (published) ? "✔" : "•",
            created_at:  created_at.to_s(:admin_date)
          }
        end
      end
    end
  end
end
