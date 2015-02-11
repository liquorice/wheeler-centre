class CacheBusterController < ActionController::Metal
  include ActionController::MimeResponds

  def index
    headers["Content-Type"] = "application/javascript"

    if params[:edge_url].present?
      edge_url = params[:edge_url].gsub("http:/", "http://").gsub("https:/", "https://")
      page_check = PageCacheCheck.find_or_create_by(edge_url: edge_url)

      BustPageCacheJob.enqueue page_check.id if page_check.requires_check?

      self.response_body = params[:debug] ? debug_response_js(page_check) : ""
    end
  end

  private

  def debug_response_js(page_check)
    ";(function() { if (typeof console !== 'undefined' && console !== null) { if (typeof console.debug === 'function') { console.debug('Reactive Cache Buster updated at: #{page_check.updated_at}'); } } })();"
  end
end
