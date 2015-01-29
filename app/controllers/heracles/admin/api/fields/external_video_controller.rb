require "#{Rails.root}/lib/video_migration/oauth_util"

module Heracles
  module Admin
    module Api
      module Fields

        class ExternalVideoController < Heracles::Admin::ApplicationController

          def index
            results = fetch_video params[:url]
            render json: results
          end

        private

          def fetch_video(url)
            @url = url
            extract_id
            hit_api
            return_results
          end

          def extract_id
            regex = /youtube.com.*(?:\/|v=)([^&$]+)/
            @id   = @url.match(regex)[1]
          end

          def hit_api
            auth_client = Google::APIClient.new(application_name: 'wheeler-centre', application_version: '1.0')
            youtube = auth_client.discovered_api('youtube', 'v3')
            auth_util = CommandLineOAuthHelper.new('https://www.googleapis.com/auth/youtube')
            auth_client.authorization = auth_util.authorize()
            @request = auth_client.execute(
              api_method: youtube.videos.list,
              parameters: {
                id: @id,
                part: 'snippet, statistics, fileDetails, contentDetails, recordingDetails, processingDetails'
              }
            )
          end

          def return_results
            @data = JSON.parse(@request.body)
            if @data['items']
              if @data['items'].size > 0
                @data = @data['items'][0]
                pin_snippet
                pin_duration
              else
                @data = []
              end
            end
            @data
          end

          def pin_snippet
            snippet = @data['snippet']
            @data = if snippet
              @data.merge(
                title: snippet['title'],
                thumbnail: snippet['thumbnails']['default']['url']
              )
            end
          end

          def pin_duration
            details = @data['contentDetails']
            @data = if details
              duration = details['duration']
              seconds  = ISO8601::Duration.new(duration).to_seconds
              @data.merge(duration: Time.at(seconds).utc.strftime("%H:%M:%S"))
            end
          end

        end

      end
    end
  end
end
