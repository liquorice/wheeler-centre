module Heracles
  module Sites
    module WheelerCentre
      class Sponsors < Heracles::Page
        def self.config
          {
            fields: [
              {name: :intro, label: "Introduction", type: :content},
              {name: :body, type: :content},
              {name: :government_partners, type: :associated_pages, page_type: :sponsor},
              {name: :patrons, type: :content},
              {name: :major_sponsors, type: :associated_pages, page_type: :sponsor},
              {name: :trusts_foundations, type: :associated_pages, page_type: :sponsor},
              {name: :ministry_of_ideas, type: :associated_pages, page_type: :sponsor},
              {name: :venue_partners, type: :associated_pages, page_type: :sponsor},
            ]
          }
        end
      end
    end
  end
end
