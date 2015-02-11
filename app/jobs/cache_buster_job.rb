require 'open-uri'
require 'digest/md5'

class CacheBusterJob < Que::Job
  def run(id)
    @page_check = CacheBuster.find(id)

    purge_page if should_purge_page?
    update_page_check
  end

  private

  def should_purge_page?
    @page_check.checksum.present? && @page_check.checksum != current_page_checksum
  end

  def purge_page
    client = Varnisher::Purger.new('PURGE', @page_check.path, ENV['CDN_HOST'])
    purge = client.send
  end

  def update_page_check
    @page_check.update(checksum: current_page_checksum, updated_at: Time.current)
  end

  memoize \
  def current_page_origin_uri
    edge_uri  = URI(@page_check.path)
    edge_hostname   = edge_uri.port == 80 ? edge_uri.hostname : "#{edge_uri.hostname}:#{edge_uri.port}"
    origin_hostname = Heracles::Site.find_by_hostname(edge_hostname).origin_hostname
    "http://#{origin_hostname}#{edge_uri.path}"
  end

  memoize \
  def current_page_checksum
    Digest::MD5.hexdigest(current_page_contents)
  end

  memoize \
  def current_page_contents
    basic_auth_user     = ENV['BASIC_AUTH_USER']
    basic_auth_password = ENV['BASIC_AUTH_PASSWORD']

    source = if basic_auth_password && basic_auth_user
      open(current_page_origin_uri, http_basic_authentication: [basic_auth_user, basic_auth_password])
    else
      open(current_page_origin_uri)
    end

    source.read
  end
end
