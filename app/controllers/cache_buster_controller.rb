class CacheBusterController < ActionController::Metal
  include AbstractController::Rendering
  include ActionController::MimeResponds
  include ActionView::Layouts
  include ActionController::Redirecting
  include Rails.application.routes.url_helpers
  require 'uri'

  append_view_path "#{Rails.root}/app/views"

  def index
    uri = URI.parse request.referer
    uri_path = uri.path

    # It checks in the Redis DB to see when the page was last accessed
    @hit = CacheBuster.find_or_create_by path: uri_path

    respond_to :js
  end

  def hits
    @hits = CacheBuster.all.order('updated_at DESC')
    respond_to :html
  end

  def hits_clean
    CacheBuster.destroy_all
    redirect_to :back
  end

end
