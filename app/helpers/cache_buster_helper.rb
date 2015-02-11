module CacheBusterHelper

  def cache_buster_script(site)
    src = if Rails.env.production?
      cache_buster_check_url("#{request.original_url}/_check.js", domain: site.origin_hostname)
    else
      cache_buster_check_url("#{request.original_url}/_check.js", debug: true, domain: ENV['CDN_ORIGIN_DOMAIN'], port: ENV['CDN_ORIGIN_PORT'])
    end
    content_tag :script, nil, async: true, src: src
  end

end
