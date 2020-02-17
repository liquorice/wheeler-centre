module Heracles
  class CreateAsset
    include Interactor

    def call
      asset = Asset.new(context.asset_params.merge(site: context.site))

      if asset.save
        context.asset = asset
        ProcessAssetJob.perform_now_or_later_as_required(asset)
      else
        context.fail! errors: asset.errors
      end
    end
  end
end
