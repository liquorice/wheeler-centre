module Heracles
  module Sites
    module WheelerCentre
      class Sponsors < Heracles::Page
        def self.config
          {
            fields: [
              {name: :intro, label: "Introduction", type: :content},
              {name: :body, type: :content},
              {name: :patrons_content, type: :content},
              {name: :government_partners, type: :associated_pages, page_type: :sponsor},
              {name: :major_partners, type: :associated_pages, page_type: :sponsor},
              {name: :program_partners, type: :associated_pages, page_type: :sponsor},
              {name: :supporting_partners, type: :associated_pages, page_type: :sponsor},
              {name: :trusts_and_foundations, type: :associated_pages, page_type: :sponsor},
              {name: :resident_organisations, type: :associated_pages, page_type: :sponsor},
            ]
          }
        end
      end
    end
  end
end
