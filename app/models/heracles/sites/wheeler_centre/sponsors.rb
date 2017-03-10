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
              {name: :patrons_content, type: :content},
              {name: :major_partners, type: :associated_pages, page_type: :sponsor},
              {name: :accomodation, type: :associated_pages, page_type: :sponsor},
              {name: :audio_visual, type: :associated_pages, page_type: :sponsor},
              {name: :fellowships_and_residencies, type: :associated_pages, page_type: :sponsor},
              {name: :special_projects, type: :associated_pages, page_type: :sponsor},
              {name: :venue_partners, type: :associated_pages, page_type: :sponsor},
              {name: :resident_organisations, type: :associated_pages, page_type: :sponsor},

            ]
          }
        end
      end
    end
  end
end
