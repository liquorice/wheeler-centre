module Heracles
  class CloudinaryAssetPresenter
    attr_reader :asset

    def self.for_asset(asset)
      new(asset)
    end

    def initialize(asset)
      @asset = asset
    end

    def cloudinary_id(base_mapping=nil)
      [base_mapping, asset.original_path].join("/")
    end
  end
end
