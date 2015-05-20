class EmbedAssetController < ApplicationController
  layout "embed"

  def show
    @asset_type = params[:asset_type].to_sym

    if available_asset_types.include?(@asset_type)
      page   = Heracles::Page.find(params[:asset_id])
      @asset = page.fields[@asset_type]
      @title = params[:title].present? ? params[:title] : page.title
    else
      raise ArgumentError, "Wrtong asset type"
    end
  end

  private

  def available_asset_types
    %i(audio)
  end

end
