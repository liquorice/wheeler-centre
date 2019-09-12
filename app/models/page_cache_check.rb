require "uri"

class PageCacheCheck < ActiveRecord::Base
  memoize \
  def site
    Heracles::Site.find_by_edge_hostname(edge_hostname) ||
      Heracles::Site.find_by_origin_hostname(edge_hostname)
  end

  def path
    if edge_uri.host =~ /^thenextchapter\./
      "/thenextchapter" + edge_uri.request_uri
    elsif edge_uri.host =~ /^broadside\./
      "/broadside" + edge_uri.request_uri
    else
      edge_uri.request_uri
    end
  end

  def edge_url
    # Add back a URL scheme: edge URLs are posted without one.
    "http://#{read_attribute(:edge_url)}"
  end

  def edge_hostname
    edge_uri.port == 80 ? edge_uri.hostname : "#{edge_uri.hostname}:#{edge_uri.port}"
  end

  def origin_url
    "http://#{origin_hostname}#{path}" if origin_hostname.present?
  end

  def origin_hostname
    site.try(:primary_origin_hostname)
  end

  def requires_check?
    updated_at < 5.minutes.ago
  end

  def site?
    !!site
  end

  private

  memoize \
  def edge_uri
    URI(edge_url)
  end
end
