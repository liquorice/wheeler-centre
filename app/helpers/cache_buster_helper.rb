module CacheBusterHelper

  def cache_buster_script
    src = if Rails.env.production?
      "http://#{@site.origin_hostname}/_check/#{CGI::escape("#{request.original_url}/_check.js")}"
    else
      cache_buster_check_url("#{request.original_url}/_check.js", debug: true, domain: ENV['CDN_ORIGIN_DOMAIN'], port: ENV['CDN_ORIGIN_PORT'])
    end
    content_tag :script, nil, async: true, src: src
  end

end
