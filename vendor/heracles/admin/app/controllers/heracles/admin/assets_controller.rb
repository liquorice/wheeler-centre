module Heracles
  module Admin
    class AssetsController < ApplicationController
      include Transloadit::Rails::ParamsDecoder

      # The React components for saving assets don't currently handle these tokens
      skip_before_action :verify_authenticity_token

      respond_to :html

      expose(:assets) { find_assets }
      expose(:asset, model: "heracles/asset")

      def create
        # TODO: move into an exposure?
        result = CreateAssetsFromTransloaditResponse.call(site: site, transloadit: params[:transloadit])

        if result.success?
          respond_with(result.assets, location: site_assets_path(site))
        else
          # TODO: error message?
          render "index"
        end
      end

      private

      def find_assets
        site.assets.page(params[:page]).per(20)
      end
    end
  end
end
