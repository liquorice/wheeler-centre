class SearchesController < ApplicationController

  before_filter :set_cache_headers_for_page, only: [:show]

  def show
    @search = GlobalSearch.new do
      adjust_solr_params do |params|
        params[:q] = "{!q.op=OR} #{params[:q]}"
      end

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
                            "collection",
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
                            "book_review",
                            "review",
                            "response",
                            "resident",
                            "sponsor",
                            "itunes_category",
                            "vpla_category",
                            "review",
                            "long_view_review",
                            "campaign_word",
                            "ticker_action",
                            "ticker_text"]

      # Exclude hidden items
      with :hidden, false

      paginate page: params[:page] || 1, per_page: 40
    end
  end

  protected

  def set_cache_headers_for_page
    if Rails.env.production?
      response.headers["Surrogate-Control"] = "max-age=#{1.day.to_i}"
      response.headers["Cache-Control"] = "s-maxage=86400, max-age=60, public"
      # Remove "Set-Cookie" header
      request.session_options[:skip] = true
    end
  end

end
