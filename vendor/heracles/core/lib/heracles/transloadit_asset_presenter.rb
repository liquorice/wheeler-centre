module Heracles
  class TransloaditAssetPresenter
    attr_reader :data

    def self.for_asset(asset)
      processed_asset = asset.processed_assets.by_processor(:transloadit).first
      return unless processed_asset

      new(processed_asset.data)
    end

    def initialize(processed_asset_data)
      @data = processed_asset_data.deep_symbolize_keys
    end

    def versions
      data[:versions].keys
    end

    def has_version?(name)
      versions.include?(name.to_sym)
    end

    def version(name)
      version_data = data[:versions][name.to_sym].try(:first)
      Version.new(version_data) if version_data
    end

    private

    class Version
      attr_reader :data

      def initialize(version_data)
        @data = version_data
      end

      %i(width height size url ssl_url).each do |attr|
        define_method(attr) do
          data[attr]
        end
      end
    end
  end
end
