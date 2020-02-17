module Heracles
  class ProcessedAssetMissing < StandardError; end

  module AssetsHelper
    def self.presenter_macros_for_processor(processor_name)
      processor_name = processor_name.to_s

      mod = Module.new
      mod.module_eval <<-RUBY
        def present_processed_asset(method)
          mod = Module.new do
            define_method(method) do |asset, *args|
              return super(asset, *args) if asset.is_a?(Heracles::#{processor_name.camelize}AssetPresenter)

              if (processed_asset_presenter = Heracles::#{processor_name.camelize}AssetPresenter.for_asset(asset))
                super(processed_asset_presenter, *args)
              else
                raise ProcessedAssetMissing, "#{processor_name.humanize} processed asset not found for this asset"
              end
            end
          end
          prepend mod
        end
      RUBY

      mod
    end
  end
end
