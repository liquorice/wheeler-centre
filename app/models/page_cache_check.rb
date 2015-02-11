require 'uri'

class PageCacheCheck < ActiveRecord::Base

  def uri
    URI(self.edge_uri)
  end

  def page_path
    uri.path
  end

  def edge_hostname
    uri.port == 80 ? uri.hostname : "#{uri.hostname}:#{uri.port}"
  end

  def origin_hostname
    site = Heracles::Site.find_by_hostname(edge_hostname)
    site.origin_hostname.nil? ? edge_hostname : site.origin_hostname
  end

  def origin_uri
    "http://#{origin_hostname}#{page_path}"
  end

end
