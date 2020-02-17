module Heracles
  class DeleteAsset
    include Interactor

    def call
      delete_files_from_s3
      context.asset.destroy
    end

    private

    def delete_files_from_s3
      # This ia a destructive operation. Run in production only.
      return unless Rails.env.production?

      begin
        aws = AWS::S3.new(access_key_id: ENV['ASSETS_AWS_ACCESS_KEY_ID'], secret_access_key: ENV['ASSETS_AWS_SECRET_ACCESS_KEY'])
        bucket = aws.buckets[ENV['ASSETS_AWS_BUCKET']]
        original = self.results[:original]
        prefix = URI.parse(original[:url]).path.gsub(/^\//, '').gsub(original[:name], '')
        bucket.objects.with_prefix(prefix).delete_all
      rescue => e
        Rails.logger.error { "#{e.message} #{e.backtrace.join("\n")}" }
      end
    end
  end
end
