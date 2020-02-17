module Heracles
  module Uploads
    class S3Backend < Refile::S3
      def self.backend_for_site(site)
        new(
          access_key_id: site.configuration.aws_s3_access_key_id,
          secret_access_key: site.configuration.aws_s3_secret_access_key,
          region: site.configuration.aws_s3_region,
          bucket: site.configuration.aws_s3_bucket,
          prefix: site.configuration.aws_s3_prefix
        )
      end

      def presign(params = {})
        id = NamedFileHasher.new.hash(params[:file_name])
        presigned_post = build_presigned_post(id, params)

        Refile::Signature.new(as: "file", id: id, url: presigned_post.url.to_s, fields: presigned_post.fields)
      end

      private

      # Private: Build a PresignedPost for a client-side S3 upload form.
      #
      # Incorporate a content_type, so the upload file is served correctly
      # from S3. Set the permissions on the file to be publicly readable, so
      # it can be used as a public link or processed by any Heracles Asset
      # processors.
      #
      # Returns the PresignedPost.
      def build_presigned_post(id, params = {})
        @bucket.presigned_post(key: [*@prefix, id].join("/")).tap do |post|
          post.content_length_range(0..@max_size) if @max_size
          post.content_type(params[:content_type]) if params[:content_type].present?
          post.acl("public-read")
        end
      end
    end
  end
end
