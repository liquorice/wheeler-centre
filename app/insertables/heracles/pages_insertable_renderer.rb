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
      site.pages.reorder(pages_order_sql(page_ids)).find(page_ids) if page_ids.present?
    end

    def pages_order_sql(page_ids)
      sql = "CASE pages.id "
      page_ids.each_with_index do |id, position|
        sql += "WHEN '#{id}' THEN #{position} "
      end
      sql += "END"
      sql
    end
  end
end
