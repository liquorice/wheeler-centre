module Heracles
  module Sites
    module WheelerCentre
      class Topic < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :intro, label: "Introduction", type: :content},
              {name: :body, type: :content}
            ]
          }
        end

        ### Accessors

        def pages
          insertion_keys_for_self_and_descendents = [insertion_key] + children.of_type(page_type).select(:id, :type).map(&:insertion_key)

          Heracles::Page.
            joins(:insertions).
            where(
              :"insertions.field" => "topics",
              :"insertions.inserted_key" => insertion_keys_for_self_and_descendents).
            group("pages.id") # we can't use `distinct` here since it fails for queries returning JSON column
        end
      end
    end
  end
end
