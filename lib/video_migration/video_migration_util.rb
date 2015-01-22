#!/usr/bin/ruby

# Usage
# >> video_migration_util = VideoMigrationUtil.new
# >> video_migration_util.upload_video(file_name, video)

require "rubygems"
require "google/api_client"
require "./oauth_util"
require "trollop"
require "yaml"

YOUTUBE_READ_WRITE_SCOPE = 'https://www.googleapis.com/auth/youtube.upload'
YOUTUBE_API_SERVICE_NAME = 'youtube'
YOUTUBE_API_VERSION = 'v3'

video_data = 'video_data.json'

if File.exist? video_data
  File.open(video_data, "r") do |file|
    data = JSON.load(file)
    @video_path = data["file_path"]
    @video_title = data["title"]
    @video_description = data["description"]
    @video_category_id = data["category_id"]
    @video_keywords = data["keywords"]
    @video_privacy_status = data["privacy_status"]
    @video_recording_date = data["recording_date"]
  end
end

@auth_client = Google::APIClient.new(:application_name => $0, :application_version => '1.0')
@youtube = @auth_client.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)

@auth_util = CommandLineOAuthHelper.new(YOUTUBE_READ_WRITE_SCOPE)
@auth_client.authorization = @auth_util.authorize()

body = {
  :snippet => {
    :title => @video_title,
    :description => @video_description,
    :tags => @video_keywords.split(','),
    :categoryId => @video_category_id,
  },
  # :recordingDetails => {
  #   :recordingDate => @video_recording_date
  # },
  :status => {
    :privacyStatus => @video_privacy_status
  }
}

# Call the API's videos.insert method to create and upload the video.
videos_insert_response = @auth_client.execute!(
  :api_method => @youtube.videos.insert,
  :body_object => body,
  :media => Google::APIClient::UploadIO.new(@video_path, 'video/*'),
  :parameters => {
    'uploadType' => 'multipart',
    :part => body.keys.join(','),
    :authorization => @auth_client
  }
)

File.open("response_data.json", "w", 0600) do |file|
  json = JSON.dump(videos_insert_response.data)
  file.write(json)
end

puts "'#{videos_insert_response.data.snippet.title}' (video id: #{videos_insert_response.data.id}) was successfully uploaded."
