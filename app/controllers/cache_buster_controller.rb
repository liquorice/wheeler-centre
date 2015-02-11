class CacheBusterController < ActionController::Metal
  include ActionController::MimeResponds

  def index
    headers['Content-Type'] = 'application/javascript'

    unless params[:edge_uri].blank?
      # It checks in the Redis DB to see when the page was last accessed
      edge_uri = params[:edge_uri].gsub('/_check', '')
      hit = PageCacheCheck.find_or_create_by edge_uri: edge_uri

      # If it was more than 5 minutes ago (or never before), then it fires off a background job to check the page
      BustPageCacheJob.enqueue hit.id if hit.updated_at <= 5.minutes.ago
      self.response_body = params[:debug].present? ? ";(function() { if (typeof console !== 'undefined' && console !== null) { if (typeof console.debug === 'function') { console.debug('Reactive Cache Buster updated at: #{hit.updated_at}'); } } })();" : ''
    end
  end
end
