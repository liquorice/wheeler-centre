module CacheBusterHelper
  def cache_buster_script(site)
    return if !site.has_edge_delivery?
    return if Rails.env.production? && site.edge_hostnames.include?(request.host)

    host = (request.port == 80 ? request.host : request.host_with_port)

    src = "//#{site.primary_origin_hostname}/_check/#{host}#{request.path}/_check.js#{('?' + request.query_string) if request.query_string.present?}"
    content_tag :script, nil, async: true, src: src
  end
end
