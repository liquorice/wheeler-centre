class CacheBusterController < ActionController::Metal
  include ActionController::MimeResponds
  include AbstractController::Rendering
  include ActionView::Layouts

  append_view_path "#{Rails.root}/app/views"

  def index
    headers['Content-Type'] = 'application/javascript'

    unless params[:edge_uri].blank?
      # It checks in the Redis DB to see when the page was last accessed
      edge_uri = params[:edge_uri].gsub('/_check', '')
      hit = CacheBuster.find_or_create_by path: edge_uri

      # If it was more than 5 minutes ago (or never before), then it fires off a background job to check the page
      CacheBusterJob.enqueue hit.id if hit.updated_at <= 5.minutes.ago
      render text: ";(function() { if (typeof console !== 'undefined' && console !== null) { if (typeof console.debug === 'function') { console.debug('Reactive Cache Buster updated at: #{hit.updated_at}'); } } })();"
    end
  end
end
