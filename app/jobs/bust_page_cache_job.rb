require 'open-uri'
require 'digest/md5'

class BustPageCacheJob < Que::Job
  def run(id)
    @page_check = PageCacheCheck.find(id)

    purge_page if should_purge_page?
    update_page_check
  end

  private

  def should_purge_page?
    Rails.env.production? && @page_check.checksum.present? && @page_check.checksum != current_page_checksum
  end

  def purge_page
    client = Varnisher::Purger.new('PURGE', @page_check.path, @page_check.edge_hostname)
    client.send
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
      open(@page_check.origin_url, http_basic_authentication: [basic_auth_user, basic_auth_password])
    else
      open(@page_check.origin_url)
    end

    source.read
  end
end
