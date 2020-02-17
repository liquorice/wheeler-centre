require "uri"

module Heracles
  # Internal: Import the original file for an `Asset` into Cloudinary and save
  # its metadata after Cloudinary has processed it.
  #
  # Requires the following context keys:
  #
  # asset - a persisted `Asset` record.
  #
  # Examples
  #
  #   ImportAssetIntoCloudinary.call(asset: asset)
  #
  # Does not set anything new in the context.
  class ImportAssetIntoCloudinary
    include Interactor

    def call
      import_asset_into_cloudinary
      save_asset_metadata
    end

    private

    # Private: Import the uploaded asset into cloudinary.
    #
    # This just requires a simple HTTP HEAD request for the file on its
    # Cloudinary URL. This will trigger Cloudinary to import the file from its
    # original location on S3.
    def import_asset_into_cloudinary
      uri = URI(context.asset.cloudinary_url)

      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true

      head_request = Net::HTTP::Head.new(uri.path)

      https.request(head_request)
    end

    # Private: Save the uploaded asset's metadata.
    def save_asset_metadata
      context.asset.original_width = metadata["width"]
      context.asset.original_height = metadata["height"]
      context.asset.save!
    end

    # Private: Fetch the uploaded asset's metadata from the Cloudinary API.
    #
    # Examples
    #
    #   metadata
    #   # => {"public_id" => "some/image.jpg", "width" => 1024, "height" => 768}
    #
    # Returns a hash of file attributes.
    memoize \
    def metadata
      Cloudinary::Api.resources_by_ids([context.asset.cloudinary_resource_id])["resources"].try(:first)
    end
  end
end
