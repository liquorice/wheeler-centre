module Heracles
  module Sites
    module WheelerCentre
      class ExternalVideoField < Heracles::Fielded::Field

        data_attribute :value
        data_attribute :embed
        validates :embed, presence: {message: 'field data must be populated before save'}, if: :field_value_defined

        def data_present?
          value.present?
        end

        def assign(attributes={})
          attributes.symbolize_keys!
          self.value   = attributes[:value].presence
          self.embed   = attributes[:embed].presence
        end

        def to_s
          value.to_s
        end

        def to_summary
          value.present? ? to_s.truncate(100) : ""
        end

        def fetch
          embed_data = fetch_oembed_data [self.value]
          self.embed = embed_data.first.marshal_dump if embed_data
        end

        def field_value_defined
          self.value.present?
        end

      private

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
