class CacheBusterController < ActionController::Metal
  include ActionController::MimeResponds

  def index
    headers["Content-Type"] = "application/javascript"

    if params[:edge_url].present?
      # Preserve any query params we have here: they were part of the original URL.
      edge_url = "#{params[:edge_url]}#{('?' + request.query_string) if request.query_string.present?}"

      page_check = PageCacheCheck.find_or_create_by(edge_url: edge_url)

      BustPageCacheJob.enqueue page_check.id if page_check.requires_check?

      #self.response_body = Rails.env.development? ? debug_response_js(page_check) : ""
      self.response_body = debug_response_js(page_check, edge_url)
    end
  end

  private

  def debug_response_js(page_check, edge_url)
    ";(function() { if (typeof console !== 'undefined' && console !== null) { if (typeof console.debug === 'function') { console.debug('Page cache check registered #{page_check.edge_url} (#{edge_url} – #{page_check.requires_check?} – #{Time.now}) at #{page_check.updated_at}'); } } })();"
  end
end
