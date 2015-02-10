require "open-uri"
require 'digest/md5'

class CacheBusterJob < Que::Job
  def run(id)
    @page_check = CacheBuster.find(id)
    @uri = "http://#{ENV['CDN_ORIGIN']}#{@page_check.path}"

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
  def current_page_checksum
    Digest::MD5.hexdigest(current_page_contents)
  end

  memoize \
  def current_page_contents
    basic_auth_user     = ENV['BASIC_AUTH_USER']
    basic_auth_password = ENV['BASIC_AUTH_PASSWORD']

    source = if basic_auth_password && basic_auth_user
      open(@uri, http_basic_authentication: [basic_auth_user, basic_auth_password])
    else
      open(@uri)
    end

    source.read
  end
end
