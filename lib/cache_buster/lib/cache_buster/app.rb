require 'sinatra/base'
require 'pathname'
require 'uri'
require 'redis'
require 'resque'
require 'ohm'
require 'cache_buster/hit'
require 'cache_buster/hit_job'
require 'cache_buster/version'

GEMDIR = Pathname.new(File.expand_path(File.join(File.dirname(__FILE__), '..')))
REDIS = URI.parse(ENV['REDISTOGO_URL'])

module CacheBuster
  class App < Sinatra::Base
    this_dir = GEMDIR.join('cache_buster')
    set :views,  this_dir.join('views')

    Resque.redis = Redis.new(host: REDIS.host, port: REDIS.port, password: REDIS.password)

    get '/' do
      content_type 'application/javascript'

      uri = URI.parse request.referer
      uri_path = uri.path

      # It checks in the Redis DB to see when the page was last accessed
      @hit = Hit.with  :page, uri_path
      @hit = Hit.create page: uri_path if @hit.nil?

      # If it was more than 5 minutes ago (or never before), then it fires off a background job to check the page
      if @hit.updated_at.nil? || Time.parse(@hit.updated_at) <= Time.now - (5*60)
        Resque.enqueue(HitJob, @hit.id)
      end

      erb "console.debug('Reactive Cache Buster enabled: #{@hit.updated_at}')"
    end

    get '/hits' do
      @info = Resque.info
      @hits = Hit.all
      erb :hits
    end

    post '/hits' do
      Hit.all.each {|hit| hit.delete}
      redirect '/hits'
    end

  end
end
