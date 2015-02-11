class CacheBusterController < ActionController::Metal
  include ActionController::MimeResponds
  include ActionController::Redirecting
  include AbstractController::Rendering
  include ActionView::Layouts
  include Rails.application.routes.url_helpers
  require 'uri'

  append_view_path "#{Rails.root}/app/views"

  def index
    headers['Content-Type'] = 'application/javascript'

    unless request.referer.blank?
      uri = URI.parse request.referer
      uri_path = uri.path

      # It checks in the Redis DB to see when the page was last accessed
      hit = CacheBuster.find_or_create_by path: uri_path

      # If it was more than 5 minutes ago (or never before), then it fires off a background job to check the page
      CacheBusterJob.enqueue hit.id if hit.updated_at <= 5.minutes.ago
      render text: ";(function() { if (typeof console !== 'undefined' && console !== null) { if (typeof console.debug === 'function') { console.debug('Reactive Cache Buster updated at: #{hit.updated_at}'); } } })();"
    end
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
