class EmbedAssetController < ApplicationController
  layout "embed"
  after_filter :allow_x_frame_options

  def show
    @asset_type = params[:asset_type].to_sym

    if available_asset_types.include?(@asset_type)
      @asset = Heracles::Asset.find(params[:asset_id])
      @title = params[:title].present? ? params[:title] : @asset.title
    else
      raise ArgumentError, "Wrong asset type"
    end
  end

  private

  def available_asset_types
    %i(audio)
  end

  def allow_x_frame_options
    response.headers.delete "X-Frame-Options"
  end

end
