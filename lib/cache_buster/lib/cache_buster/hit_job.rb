require 'resque'
require 'ohm'
require 'fastly'
require 'open-uri'
require 'nokogiri'
require 'dotenv'
require 'digest/md5'
require 'cache_buster/hit'

module HitJob
  @queue = :default

  def self.perform(hit_id)
    @hit = Hit[hit_id]

    request_page
    purge_page if @hit.checksum != @checksum
    update_hit

    puts "Hit for page #{@hit.page} processed!"
  end

  def self.request_page
    basic_auth_user     = ENV['BASIC_AUTH_USER']
    basic_auth_password = ENV['BASIC_AUTH_PASSWORD']
    source = if basic_auth_password && basic_auth_user
      Nokogiri::HTML(
        open(
          "http://#{ENV['CDN_ORIGIN']}#{@hit.page}",
          :http_basic_authentication => [basic_auth_user, basic_auth_password]
        )
      )
    else
      Nokogiri::HTML(
        open("http://#{ENV['CDN_ORIGIN']}#{@hit.page}")
      )
    end
    @checksum = Digest::MD5.hexdigest(source)
  end

  def self.purge_page
    client = Fastly::Client.new(api_key: ENV['FASTLY_API_KEY'])
    client.post("/service/#{ENV['FASTLY_SERVICE_ID']}/purge/#{@hit.page}")
  end

  def self.update_hit
    @hit.checksum = @checksum
    @hit.updated_at = Time.now
    @hit.save
  end
end
