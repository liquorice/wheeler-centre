class EmbedAssetController < ApplicationController
  layout "embed"
  after_filter :allow_x_frame_options
  before_filter :set_cache_headers_for_page, only: [:show]

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

  def set_cache_headers_for_page
    if Rails.env.production?
      response.headers["Surrogate-Control"] = "max-age=#{1.day.to_i}"
      response.headers["Cache-Control"] = "s-maxage=86400, max-age=60, public"
      # Remove "Set-Cookie" header
      request.session_options[:skip] = true
    end
  end

end
