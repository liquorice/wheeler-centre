module Heracles
  module Sites
    module WheelerCentre
      class HomePage < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :intro, type: :content},
              # Banners
              {name: :banners, label: "Home page banners", type: :associated_pages, page_type: :home_banner},
              # Di Gribble Argument feature
              {name: :di_gribble_argument_feature_title, type: :text, label: "Di Gribble Argument feature title", hint: "Defaults to 'The Di Gribble Argument'"},
              {name: :di_gribble_argument_feature_content, type: :content, with_buttons: %i(bold italic), disable_insertables: true, label: "Di Gribble Argument feature content"},
              {name: :di_gribble_argument_feature_tags, type: :text, editor_type: :code, label: "Di Gribble Argument feature tags", hint: "Defaults to 'di-gribble-argument-feature'"},
              # Highlights
              {name: :highlights_info, type: :info, text: "<hr/>"},
              {name: :highlights_primary_title, type: :text, editor_columns: 6},
              {name: :highlights_primary_tags, type: :text, editor_type: :code, editor_columns: 6, hint: "Defaults to 'highlights'"},
              {name: :highlights_primary_content, type: :content, with_buttons: %i(bold italic), disable_insertables: true},
              {name: :highlights_secondary_title, type: :text, editor_columns: 6},
              {name: :highlights_secondary_tags, type: :text, editor_type: :code, editor_columns: 6, hint: "Separate multiple tags with a comma"},
              {name: :highlights_secondary_content, type: :content, with_buttons: %i(bold italic), disable_insertables: true},
              # Quotes
              {name: :quotes_info, type: :info, text: "<hr/>"},
              {name: :quotes_title, type: :text},
              {name: :quotes_content, type: :content, with_buttons: %i(bold italic), disable_insertables: true},
              {name: :quotes, label: "Home page quotes", type: :associated_pages, page_type: :home_quote},
              # Writings
              {name: :writings_info, type: :info, text: "<hr/>"},
              {name: :writings_title, type: :text, editor_columns: 6},
              {name: :writings_tags, type: :text, editor_type: :code, editor_columns: 6, hint: "Separate multiple tags with a comma"},
              {name: :writings_content, type: :content, with_buttons: %i(bold italic), disable_insertables: true},
              # Body
              {name: :body_info, type: :info, text: "<hr/>"},
              {name: :body, type: :content},
              # About blurb
              {name: :about_info, type: :info, text: "<hr/>"},
              {name: :about_blurb, label: "About blurb", type: :content}
            ]
          }
        end

        ### Accessors

        def sorted_banners
          if fields[:banners].data_present?
            fields[:banners].pages.visible.published.first(9)
          end
        end

        # Temporary
        # Should be replace with saved-search insertables
        def highlights(options={})
          options[:tags] = options[:tags].presence || ["highlights"]
          options.reverse_merge!({tags: options[:tags]})
          search_by_tag(options)
        end

        # Temporary
        # Should be replace with saved-search insertables
        def user_highlights(options={})
          options.reverse_merge!({tags: options[:tags]})
          search_by_tag(options)
        end

        # Temporary
        # Should be replace with saved-search insertables
        def user_writings(options={})
          options.reverse_merge!({tags: options[:tags]})
          search_user_writings(options)
        end

        def di_gribble_argument_feature_items(options={})
          tags = fields[:di_gribble_argument_feature_tags].data_present? ? fields[:di_gribble_argument_feature_tags].value.split(",") : ["di-gribble-argument-feature"]

          search_by_tag(tags: tags)
        end

        private

        def searchable_types
          [
            BlogPost,
            LongformBlogPost,
            Event,
            Recording,
            PodcastEpisode,
            Person
          ]
        end

        def search_by_tag(options={})
          # tag_list = options[:tags] if options[:tags].present?
          # result = searchable_types.map do |type|
          #   results = type.where(
          #     site_id: site.id,
          #     published: true,
          #     hidden: false
          #   ).order("fields_data->'publish_date'->>'value' DESC NULLS LAST", "created_at DESC")
          #   results = results.tagged_with(tag_list) if tag_list
          # end.flatten

          # Kaminari.paginate_array(result).page(options[:page] || 1).per(options[:per_page] || 6)

          Sunspot.search(searchable_types.flatten) do
            with :site_id, site.id
            with :published, true
            with :hidden, false
            with :tag_list, options[:tags] if options[:tags].present?
            order_by :date_sort_field, :desc
            paginate page: options[:page] || 1, per_page: options[:per_page] || 6
          end
        end

        def search_user_writings(options={})
          tag_list = options[:tags] if options[:tags].present?
          results = BlogPost.where(
            site_id: site.id,
            published: true,
            hidden: false,
          ).order("fields_data->'publish_date'->>'value' DESC NULLS LAST")
          results = results.tagged_with(tag_list) if tag_list
          results.page(options[:page] || 1).per(options[:per_page] || 6)
        end
      end
    end
  end
end
