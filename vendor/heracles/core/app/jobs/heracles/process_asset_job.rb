module Heracles
  class ProcessAssetJob < ActiveJob::Base
    queue_as :heracles_assets

    def self.perform_now_or_later_as_required(asset)
      if AssetProcessor.processors_for_site(asset.site).any?(&:requires_initial_processing?)
        perform_later(asset)
      else
        perform_now(asset)
      end
    end

    def perform(asset)
      ProcessAsset.call!(asset: asset)
    end
  end
end
