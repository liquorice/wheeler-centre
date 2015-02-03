module Heracles
  module Sites
    module WheelerCentre
      class ExternalVideoField < Heracles::Fielded::Field

        data_attribute :value
        data_attribute :youtube
        data_attribute :embed
        validates :youtube, presence: {message: 'field data must be populated before save'}, if: :field_value_defined

        def data_present?
          value.present?
        end

        def assign(attributes={})
          attributes.symbolize_keys!
          self.value   = attributes[:value].presence
          self.youtube = attributes[:youtube].presence
          self.embed   = attributes[:embed].presence
        end

        def to_s
          value.to_s
        end

        def to_summary
          value.present? ? to_s.truncate(100) : ""
        end

        def fetch
          extract_id
          hit_api
          embed_data = fetch_oembed_data [self.value]
          self.youtube = process_result
          self.embed = embed_data.first.marshal_dump if embed_data
        end

        def field_value_defined
          self.value.present?
        end

      private

        def extract_id
          regex = /youtube.com.*(?:\/|v=)([^&$]+)/
          @video_id = self.value.match(regex)[1]
        end

        def hit_api
          auth_client = Google::APIClient.new(application_name: 'wheeler-centre', application_version: '1.0')
          youtube = auth_client.discovered_api('youtube', 'v3')
          auth_util = CommandLineOAuthHelper.new('https://www.googleapis.com/auth/youtube')
          auth_client.authorization = auth_util.authorize()
          @video_request = auth_client.execute(
            api_method: youtube.videos.list,
            parameters: {
              id: @video_id,
              part: 'snippet, statistics, fileDetails, contentDetails, recordingDetails, processingDetails'
            }
          )
        end

        def process_result
          @video_data = JSON.parse(@video_request.body)
          if @video_data['items']
            if @video_data['items'].size > 0
              @video_data = @video_data['items'][0]
              pin_snippet
              pin_duration
            else
              @video_data = []
            end
          end
          @video_data
        end

        def pin_snippet
          snippet = @video_data['snippet']
          @video_data = if snippet
            @video_data.merge(
              title: snippet['title'],
              thumbnail: snippet['thumbnails']['default']['url']
            )
          end
        end

        def pin_duration
          details = @video_data['contentDetails']
          @video_data = if details
            duration = details['duration']
            seconds  = ISO8601::Duration.new(duration).to_seconds
            @video_data.merge(duration: Time.at(seconds).utc.strftime("%H:%M:%S"))
          end
        end

        def embedly_api
          @embedly_api ||= Embedly::API.new :key => ENV["EMBEDLY_API_KEY"], :user_agent => 'Mozilla/5.0 (compatible; wheelercentre/1.0; hello@icelab.com.au)'
        end

        def fetch_oembed_data(urls)
          embedly_api.oembed urls: urls, youtube_modestbranding: 1
        end
      end
    end
  end
end
