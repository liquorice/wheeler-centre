module Heracles
  class AssetProcessingFailed < StandardError; end

  module AssetProcessor
    Response = Struct.new(:processed, :data)

    def self.named(name)
      "Heracles::#{name.to_s.camelize}AssetProcessor".constantize
    end

    def self.processors_for_site(site)
      site.configuration.asset_processors.map { |processor_name|
        named(processor_name)
      }
    end
  end
end
