require "uri"

class PageCacheCheck < ActiveRecord::Base
  memoize \
  def site
    Heracles::Site.find_by_hostname(edge_hostname)
  end

  def path
    edge_uri.path
  end

  def edge_hostname
    edge_uri.port == 80 ? edge_uri.hostname : "#{edge_uri.hostname}:#{edge_uri.port}"
  end

  def origin_url
    "http://#{origin_hostname}#{path}"
  end

  def origin_hostname
    site.origin_hostname.presence || edge_hostname
  end

  def requires_check?
    updated_at < 5.minutes.ago
  end

  private

  memoize \
  def edge_uri
    URI(edge_url)
  end
end
