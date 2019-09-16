module CacheBusterHelper
  def cache_buster_script(site)
    return if !site.has_edge_delivery?
    return if Rails.env.production? && !request.headers.any?{|k, v| k.downcase == "http_via" && v.include?("cdn77")}

    host = (request.port == 80 ? request.host : request.host_with_port)

    request_path = request.path
    if request.host =~ /^thenextchapter/
      request_path.gsub!(/^\/thenextchapter/, "")
    elsif request.host =~ /^broadside/
      request_path.gsub!(/^\/broadside/, "")
    end

    src = "//#{site.primary_origin_hostname}/_check/#{host}#{request_path}/_check.js#{('?' + request.query_string) if request.query_string.present?}"
    content_tag :script, nil, async: true, src: src
  end
end
