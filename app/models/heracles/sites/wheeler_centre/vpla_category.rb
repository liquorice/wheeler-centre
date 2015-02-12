module Heracles
  module Sites
    module WheelerCentre
      class VplaCategory < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :body, type: :content},
            ]
          }
        end

        def books
          Heracles::Page.
            published.visible.
            joins(:insertions).
            where(
              :"insertions.field" => "category",
              :"insertions.inserted_key" => insertion_key
            ).
            group("pages.id"). # we can't use `distinct` here since it fails for queries returning JSON column
            order("created_at DESC")
        end
      end
    end
  end
end
