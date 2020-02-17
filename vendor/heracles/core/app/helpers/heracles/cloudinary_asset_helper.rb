module Heracles
  module CloudinaryAssetHelper
    extend AssetsHelper.presenter_macros_for_processor(:cloudinary)

    present_processed_asset def cloudinary_asset_url(asset, options={})
      asset_cloudinary_id = asset.cloudinary_id(site.configuration.cloudinary_base_mapping)

      base_options = CloudinaryAssetProcessor.cloudinary_options_for_site(site)
      options = base_options.merge(cloudinary_image_options(options.delete(:preset))).merge(options)
      options[:format] ||= File.extname(asset_cloudinary_id).gsub(/^\./, '')

      Cloudinary::Utils.cloudinary_url(without_file_extension(asset_cloudinary_id), options)
    end

    present_processed_asset def cloudinary_asset_image_tag(asset, cloudinary_options={}, html_options={})
      url = cloudinary_asset_url(asset, cloudinary_options)
      image_tag(url, html_options)
    end

    def cloudinary_asset_admin_thumbnail_url(asset)
      cloudinary_asset_url(asset, preset: :heracles_admin_thumbnail)
    end

    def cloudinary_asset_admin_preview_url(asset)
      cloudinary_asset_url(asset, preset: :heracles_admin_preview)
    end

    def cloudinary_asset_admin_thumbnail_image_tag(asset, options={})
      cloudinary_asset_image_tag(asset, options.merge(preset: :heracles_admin_thumbnail))
    end

    def cloudinary_asset_admin_preview_image_tag(asset, options={})
      cloudinary_asset_image_tag(asset, options.merge(preset: :heracles_admin_preview))
    end

    # Image presets

    def cloudinary_image_options(preset_name)
      try(:"cloudinary_image_options_for_#{preset_name}") || {}
    end

    def cloudinary_image_options_for_heracles_admin_thumbnail
      {width: 400, height: 250, crop: :fit}
    end

    def cloudinary_image_options_for_heracles_admin_preview
      {width: 720, height: 720, crop: :fit}
    end

    private

    def without_file_extension(file)
      File.join(File.dirname(file), File.basename(file, File.extname(file)))
    end
  end
end
