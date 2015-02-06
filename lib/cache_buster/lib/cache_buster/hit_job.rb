require 'resque'
require 'ohm'
require 'open-uri'
require 'nokogiri'
require 'dotenv'
require 'digest/md5'
require 'cache_buster/hit'

Ohm.redis = Redic.new(ENV['REDISTOGO_URL'])

module HitJob
  @queue = :default

  def self.perform(hit_id)
    @hit = Hit[hit_id]

    request_page
    update_hit

    puts "Hit for page #{@hit.page} processed!"
  end

  def self.request_page
    source = Nokogiri::HTML(open("http://#{ENV['CDN_ORIGIN']}#{@hit.page}"))
    @checksum = Digest::MD5.hexdigest(source)
  end

  def self.update_hit
    @hit.checksum = @checksum
    @hit.updated_at = Time.now
    @hit.save
  end
end
