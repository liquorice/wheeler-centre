#!/usr/bin/ruby

# Usage
# >> video_migration_util = VideoMigrationUtil.new
# >> video_migration_util.upload_video(file_name, video)

require "rubygems"
require "google/api_client"
require_relative "oauth_util"
require "trollop"
require "yaml"

class VideoMigrationUtil
  YOUTUBE_READ_WRITE_SCOPE = 'https://www.googleapis.com/auth/youtube.upload'
  YOUTUBE_API_SERVICE_NAME = 'youtube'
  YOUTUBE_API_VERSION = 'v3'

  def initialize
    @auth_client = Google::APIClient.new(:application_name => $0, :application_version => '1.0')
    @youtube = @auth_client.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)

    @auth_util = CommandLineOAuthHelper.new(YOUTUBE_READ_WRITE_SCOPE)
    @auth_client.authorization = @auth_util.authorize()
  end


  def upload_video(file_name, video)
    # TODO: pull these values from a video_data.json that we have created for each file
    options = Trollop::options do
      opt :file, 'Video File',
            :default => '~/' + file_name, :type => String
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
    videos_insert_response = @auth_client.execute!(
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