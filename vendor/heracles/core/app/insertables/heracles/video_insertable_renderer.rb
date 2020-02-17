module Heracles
  class VideoInsertableRenderer < InsertableRenderer
    ### Custom renderer

    def render
      # Render nothing if the video or embed data are missing
      return "" unless data[:url].present? && data[:embedData].present?
      @poster_asset = @options[:site].assets.images.find_by_id(data[:asset_id]) if data[:asset_id].present?
      super
    end

    ### Helpers

    helper_method \
    def wrapper_div_class
      "figure figure__video figure__display--#{(data[:display] || "default").downcase}"
    end

    helper_method \
    def responsive_embed_div_style
      # The ratio is coupled with CSS to make the embed responsive
      ratio = data[:embedData][:height].to_f / data[:embedData][:width].to_f
      "padding-bottom: #{ratio * 100}%"
    end
  end
end
