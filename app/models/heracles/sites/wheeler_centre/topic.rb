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

        def latest_pages(options={})
          insertion_keys_for_self_and_descendents = [insertion_key] + children.of_type(page_type).select(:id, :type).map(&:insertion_key)

          Heracles::Page.
            published.visible.
            joins(:insertions).
            where(
              :"insertions.field" => "topics",
              :"insertions.inserted_key" => insertion_keys_for_self_and_descendents).
            where.not(type: "Heracles::Sites::WheelerCentre::LongformBlogPost").
            group("pages.id"). # we can't use `distinct` here since it fails for queries returning JSON column
            order("created_at DESC").
            page(options[:page_number] || 1).
            per(options[:per_page] || 6)
        end

        def random_pages(options={})
          insertion_keys_for_self_and_descendents = [insertion_key] + children.of_type(page_type).select(:id, :type).map(&:insertion_key)

          Heracles::Page.connection.execute("SELECT setseed(0.#{Time.current.beginning_of_day.to_i});")
          Heracles::Page.
            published.visible.
            joins(:insertions).
            where(
              :"insertions.field" => "topics",
              :"insertions.inserted_key" => insertion_keys_for_self_and_descendents).
            where.not(type: "Heracles::Sites::WheelerCentre::LongformBlogPost").
            group("pages.id"). # we can't use `distinct` here since it fails for queries returning JSON column
            order("random()").
            page(options[:page_number] || 1).
            per(options[:per_page] || 18)
        end

        # Return a list of this topic and its topic-ancestors
        def with_ancestors
          [self] + self.ancestors.of_type("topic").visible.published
        end

        def csv_headers
          [
            "ID",
            "Title",
            "URL",
            "Body",
            "Intro",
            "Updated at",
            "Created at",
          ]
        end

        def to_csv
          [
            id,
            title,
            absolute_url,
            fields[:intro],
            fields[:body],
            updated_at,
            created_at,
          ]
        end
      end
    end
  end
end
