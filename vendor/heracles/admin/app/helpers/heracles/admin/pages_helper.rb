module Heracles
  module Admin
    module PagesHelper
      def cancel_page_editing_path(page)
        if page.persisted?
          if page.collection_id.present?
            edit_site_collection_page_path(site, page.collection_id, page)
          else
            edit_site_page_path(site, page)
          end
        elsif page.parent
          edit_site_page_path(site, page.parent, open_tree_nav: true)
        else
          site_pages_path(site, open_tree_nav: true)
        end
      end

      def allowed_alternative_page_types(page)
        page.allowed_alternative_page_classes.map { |page_class| [page_class.page_type.humanize, page_class.page_type] }
      end
    end
  end
end
