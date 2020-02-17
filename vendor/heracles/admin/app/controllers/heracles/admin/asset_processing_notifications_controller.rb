module Heracles
  module Admin
    class AssetProcessingNotificationsController < ApplicationController
      skip_before_filter :authenticate_heracles_admin_user

      def create
        asset = Heracles::Asset.find(params[:asset_id])
        ProcessAssetNotification.call(asset: asset, processor_name: params[:processor_name], notification_data: params)
      end
    end
  end
end
