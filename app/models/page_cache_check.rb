require 'uri'

class PageCacheCheck < ActiveRecord::Base

  def uri
    URI(self.edge_uri)
  end

  def page_path
    self.uri.path
  end

  def edge_hostname
  end

  def original_hostname
  end

  def original_uri
  end

end
