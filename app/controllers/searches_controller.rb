class SearchesController < ApplicationController

  def show
    @search = GlobalSearch.new do
      fulltext params[:q]
      with :published, true
      with :site_id, site.id
      facet :page_type

      if params[:order] == "newest"
        order_by :created_at, :desc
      elsif params[:order] == "oldest"
        order_by :created_at, :asc
      end

      if params[:page_type].present?
        with :page_type, params[:page_type]
      end

      # We never want the listing pages to show up in the search
      without :page_type, [ "blog",
                            "broadcasts",
                            "criticism_now",
                            "event_series_index",
                            "events",
                            "events_archive",
                            "guests",
                            "home_page",
                            "people",
                            "placeholder",
                            "podcasts",
                            "presenters",
                            "settings",
                            "sponsors",
                            "texts_in_the_city",
                            "topics",
                            "venues"]

      # Also exclude all the things for which we don't have an individual-level view
      without :page_type, [ "texts_in_the_city_book",
                            "home_banner",
                            "vpla_year",
                            "zoo_fellowships_work",
                            "review",
                            "response",
                            "resident",
                            "sponsor",
                            "itunes_category",
                            "vpla_category",
                            "review",
                            "long_view_review"]

      paginate page: params[:page] || 1, per_page: 40
    end
  end
end
