require "#{Rails.root}/lib/video_migration/oauth_util"

module Heracles
  module Admin
    module Api
      module Fields

        class ExternalVideoController < Heracles::Admin::ApplicationController

          def index
            regex = /youtube.com.*(?:\/|v=)([^&$]+)/
            id = params[:url].match(regex)[1]
            request = hit_api id
            render json: request.body
          end

        private

          def hit_api(id)
            @auth_client = Google::APIClient.new(application_name: 'wheeler-centre', application_version: '1.0')
            @youtube = @auth_client.discovered_api('youtube', 'v3')
            @auth_util = CommandLineOAuthHelper.new('https://www.googleapis.com/auth/youtube')
            @auth_client.authorization = @auth_util.authorize()
            @auth_client.execute(api_method: @youtube.videos.list, parameters: {id: id, part: 'snippet, statistics, fileDetails, contentDetails, recordingDetails, processingDetails'})
          end

        end

      end
    end
  end
end
