module Heracles
  class PagesInsertableRenderer < InsertableRenderer
    ### Custom renderer

    def render
      # Return nothing if the asset is missing
      return "" unless pages

      super
    end

    ### Helpers

    helper_method \
    def pages
      find_pages(data[:page_ids])
    end

    private

    def find_pages(page_ids)
      site.pages.find(page_ids) if page_ids.present?
    end
  end
end
