module CacheBusterHelper

  def cache_buster_script(site)
    src = if Rails.env.production?
      "//#{site.origin_hostname}/_check/#{request.original_url}/_check.js"
    else
      "//#{ENV['CDN_ORIGIN_DOMAIN']}:#{ENV['CDN_ORIGIN_PORT']}/_check/#{request.original_url}/_check.js?debug=true"
    end
    content_tag :script, nil, async: true, src: src
  end

end
