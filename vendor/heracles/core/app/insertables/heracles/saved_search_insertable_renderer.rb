module Heracles
  class SavedSearchInsertableRenderer < InsertableRenderer
    include ActionView::Helpers::TagHelper
    include Heracles::SavedSearchHelper

    def render
      results = saved_search_results({site: @options[:site]}.merge(@data[:saved_search]))
      content_tag :div, results, class: @options[:wrapper_class].presence || "saved-search"
    end

    alias_method :controller, :rendering_controller
  end
end
