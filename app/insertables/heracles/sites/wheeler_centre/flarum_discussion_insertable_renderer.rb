module Heracles
  module Sites
    module WheelerCentre
      class FlarumDiscussionInsertableRenderer < ::Heracles::InsertableRenderer
        include ApplicationHelper

        def render
          # Render nothing if the discussion_id is missing
          return "" unless discussion_id
          super
        end

        helper_method \
        def discussion_embed_url
          "#{discussion_base_url}/embed/#{discussion_id}"
        end

        helper_method \
        def discussion_id
          data[:discussion_id] || 1
        end

        helper_method \
        def discussion_url
          "#{discussion_base_url}/d/#{discussion_id}"
        end

        helper_method \
        def discussion_title
          data[:title].present? ? markdown_line(data[:title]).html_safe : "Join the discussion"
        end

        helper_method \
        def max_height
          data[:max_height].present? ? data[:max_height].to_f : 800
        end

        private

        def discussion_base_url
          "http://#{ENV["FLARUM_HOST"]}" || "http://discuss.wheelercentre.com"
        end
      end
    end
  end
end

