module Heracles
  class AudioInsertableRenderer < InsertableRenderer
    ### Custom renderer

    def render
      # Return nothing if the asset is missing
      return "" unless asset

      # TODO: later, update this to work with actual processed assets
      return "" unless asset.content_type =~ /audio/

      super
    end

    ### Helpers

    helper_method \
    def asset
      find_asset data[:asset_id]
    end

    ### Helpers

    helper_method \
    def wrapper_div_class
      "figure figure__audio figure__display--#{(data[:display] || "default").downcase}"
    end

    # TODO: reenable these once we're working with actual processed asset records
    # helper_method \
    # def mp3_version
    #   find_version_by_mime_type "audio/mpeg"
    # end

    # helper_method \
    # def mp3_url
    #   asset.send(:"#{mp3_version[:name]}_url") if mp3_version
    # end

    # helper_method \
    # def ogg_version
    #   find_version_by_mime_type "audio/x-ogg"
    # end

    # helper_method \
    # def ogg_url
    #   asset.send(:"#{ogg_version[:name]}_url") if ogg_version
    # end

    helper_method \
    def title
      data[:title].presence || asset.title || asset.file_name
    end

    private

    def find_asset(asset_id)
      site.assets.find_by_id(asset_id) if asset_id.present?
    end

    def find_version_by_mime_type(mime_type)
      version = nil
      asset.results.each do |result_name, result|
        if result["mime"] == mime_type
          version = {
            name: result_name,
            version: result
          }
        end
      end
      version
    end
  end
end
