class SearchesController < ApplicationController

  def show
    @search = GlobalSearch.new do
      fulltext params[:q]
      with :published, true
      with :site_id, site.id

      paginate page: params[:page] || 1, per_page: 40
    end
  end

  private

  def site
    @site ||= Heracles::Site.where(slug: HERACLES_SITE_SLUG).first!
  end

  helper_method :site

end
