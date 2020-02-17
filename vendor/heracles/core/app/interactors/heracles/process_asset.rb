module Heracles
  class ProcessAsset
    include Interactor

    def call
      results = processors.map { |processor| [processor.processor_name, processor.process_asset(context.asset)] }
      context.processed_assets = results.map { |asset_results| create_processed_asset(*asset_results) }.compact

      context.asset.update processed_at: Time.current if fully_processed?
    end

    private

    def create_processed_asset(processor_name, processor_response)
      return unless processor_response

      Heracles::ProcessedAsset.create! do |processed_asset|
        processed_asset.processor = processor_name
        processed_asset.asset = context.asset
        processed_asset.data = processor_response.data
        processed_asset.processed_at = Time.current if processor_response.processed
      end
    end

    def processors
      Heracles::AssetProcessor.processors_for_site(context.asset.site)
    end

    def fully_processed?
      context.processed_assets.blank? || context.processed_assets.all?(&:processed?)
    end
  end
end
