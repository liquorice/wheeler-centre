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

      paginate page: params[:page] || 1, per_page: 40
    end
  end

  private

  def site
    @site ||= Heracles::Site.where(slug: HERACLES_SITE_SLUG).first!
  end

  helper_method :site

end