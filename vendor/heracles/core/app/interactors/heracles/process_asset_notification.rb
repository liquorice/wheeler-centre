module Heracles
  class ProcessAssetNotification
    include Interactor

    def call
      processor = Heracles::AssetProcessor.named(context.processor_name)

      processor_response = processor.process_asset_notification(context.notification_data)
      context.processed_asset = create_processed_asset(processor_response)
      context.asset.update processed_at: Time.current

      destroy_previous_processed_assets
    end

    private

    def create_processed_asset(processor_response)
      Heracles::ProcessedAsset.create! do |processed_asset|
        processed_asset.processor = context.processor_name
        processed_asset.asset = context.asset
        processed_asset.data = processor_response.data
        processed_asset.processed_at = Time.current if processor_response.processed
      end
    end

    def destroy_previous_processed_assets
      context.asset
        .processed_assets
        .by_processor(context.processor_name)
        .where("id != ?", context.processed_asset.id)
        .destroy_all
    end
  end
end
