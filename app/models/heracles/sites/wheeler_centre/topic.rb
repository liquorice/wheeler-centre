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

        def pages(options={})
          search_pages(options)
        end

        private

        def search_pages(options={})
          Sunspot.search(pages_with_topics_classes) do
            with :site_id, site.id
            with :published, true

            with :topic_ids, descendant_topics_ids << id

            order_by :created_at, :desc

            paginate page: options[:page] || 1, per_page: options[:per_page] || 20
          end
        end

        def descendant_topics_ids
          descendants.of_type("topic").map(&:id)
        end

        def pages_with_topics_classes
          [
            BlogPost,
            ContentPage,
            Event,
            EventSeries,
            Person,
            PodcastEpisode,
            PodcastSeries,
            Recording
          ]
        end
      end
    end
  end
end
