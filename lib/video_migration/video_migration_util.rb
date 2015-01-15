#!/usr/bin/ruby

# Usage
# >> video_migration_util = VideoMigrationUtil.new( config_file: 'video_migration/config.yml')
# >> video_migration_util.upload_video(public_url, video)

require "rubygems"
require "google/api_client"
require "trollop"
require "yaml"

class VideoMigrationUtil
  YOUTUBE_READ_WRITE_SCOPE = 'https://www.googleapis.com/auth/youtube'
  YOUTUBE_API_SERVICE_NAME = 'youtube'
  YOUTUBE_API_VERSION = 'v3'

  attr_accessor :config_file

  def initialize(args)
    args.each do |key, value|
      instance_variable_set("@#{key}", value)
    end

    @opts = YAML.load_file(@config_file)

    service_account_email = @opts['service_account_email']  # Email of service account
    key_file = @opts['key_file']                            # File containing your private key
    key_secret = @opts['key_secret']                        # Password to unlock private key

    # Load our credentials for the service account
    key = Google::APIClient::KeyUtils.load_from_pkcs12(key_file, key_secret)

    @auth_client = Signet::OAuth2::Client.new(
      :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
      :audience => 'https://accounts.google.com/o/oauth2/token',
      :scope => YOUTUBE_READ_WRITE_SCOPE,
      :issuer => service_account_email,
      :signing_key => key)

    @auth_client.fetch_access_token!

    @api_client = Google::APIClient.new(
      :application_name => @opts['application_name'],
      :application_version => @opts['application_version'])
    @api_client.authorization = nil

    @youtube = @api_client.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)

  end


  def upload_video(public_url, video)
    @auth_client.refresh_token

    options = Trollop::options do
      opt :file, 'Video File',
            :default => public_url, :type => String
      opt :title, 'Video title',
            :default => 'Test Title', :type => String
      opt :description, 'Video description',
            :default => 'Test Description', :type => String
      opt :categoryId, 'Numeric video category. See https://developers.google.com/youtube/v3/docs/videoCategories/list',
            :default => 22, :type => :int
      opt :keywords, 'Video keywords, comma-separated',
            :default => '', :type => String
      opt :privacyStatus, 'Video privacy status: public, private, or unlisted',
            :default => 'public', :type => String
    end

    if options[:file].nil?
      Trollop::die :file, 'does not exist'
    end

    body = {
      :snippet => {
        :title => options[:title],
        :description => options[:description],
        :tags => options[:keywords].split(','),
        :categoryId => options[:categoryId],
      },
      :status => {
        :privacyStatus => options[:privacyStatus]
      }
    }

    # Call the API's videos.insert method to create and upload the video.
    videos_insert_response = @api_client.execute!(
      :api_method => @youtube.videos.insert,
      :body_object => body,
      :media => Google::APIClient::UploadIO.new(options[:file], 'video/*'),
      :parameters => {
        'uploadType' => 'multipart',
        :part => body.keys.join(','),
        :authorization => @auth_client
      }
    )

    puts "'#{videos_insert_response.data.snippet.title}' (video id: #{videos_insert_response.data.id}) was successfully uploaded."
  end

end