require 'open-uri'
require 'digest/md5'
require 'open-uri'
require 'net/http'

class BustPageCacheJob < Que::Job
  def run(page_cache_check_id)
    @page_check = PageCacheCheck.find(page_cache_check_id)
    purge_page if should_purge_page?

    ActiveRecord::Base.transaction do
      touch_or_destroy_page_cache_check
      destroy
    end
  end

  private

  def should_purge_page?
    Rails.env.production? && \
    @page_check.site? && \
    @page_check.checksum.present? && \
    @page_check.checksum != current_page_checksum
  end

  def purge_page
    if path =~ /^\/thenextchapter/
      cdn_id = ENV['NEXT_CHAPTER_CDN77_CDN_ID']
      path = path.gsub(/^\/thenextchapter/, "")
    else
      cdn_id = ENV['CDN77_CDN_ID']
    end

    Net::HTTP.post_form(
      URI(ENV['CDN77_PURGE_ENDPOINT']),
      [
        ["login", ENV['CDN77_EMAIL']],
        ["passwd", ENV['CDN77_PASSWORD']],
        ["cdn_id", cdn_id],
        ["url[]", path]
      ]
    )
  end

  def path
    URI(@page_check.path).path
  end

  def touch_or_destroy_page_cache_check
    if @page_check.site?
      update_page_check
    else
      @page_check.destroy
    end
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
