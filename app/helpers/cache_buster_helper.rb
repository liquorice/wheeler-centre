module CacheBusterHelper
  def cache_buster_script(site)
    return if !site.has_edge_delivery?
    return if Rails.env.production? && !request.headers.any?{|k, v| k.downcase == "http_via" && v.include?("cdn77")}

    host = (request.port == 80 ? request.host : request.host_with_port)

    request_path =
      if request.host =~ /^thenextchapter/
        request.path.gsub(/^\/thenextchapter/, "")
      else
        request.path
      end

    src = "//#{site.primary_origin_hostname}/_check/#{host}#{request_path}/_check.js#{('?' + request.query_string) if request.query_string.present?}"
    content_tag :script, nil, async: true, src: src
  end
end
