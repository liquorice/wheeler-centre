#!/usr/bin/ruby

# Usage
# >> s3 = S3Util.new(bucket_name: 'video.wheelercentre.com', config_file: 'video_migration/config.yml')
# >> s3.find_video(file_name)

require "aws-sdk"
require "yaml"

class S3Util
	attr_accessor :bucket_name, :config_file

	def initialize(args)
		args.each do |key, value|
      instance_variable_set("@#{key}", value)
    end

    opts = YAML.load_file(@config_file)

		AWS.config(
		  :access_key_id => opts["MIGRATION_AWS_ACCESS_KEY_ID"],
		  :secret_access_key => opts["MIGRATION_AWS_SECRET_KEY"])

		# S3.new will use the credentials specified in your config file
		@s3 = AWS::S3.new
	end

	def find(file_name)
		bucket = @s3.buckets[@bucket_name]
		if bucket.exists?
			if bucket.objects[file_name].exists?
				puts (bucket.objects[file_name].public_url)
				bucket.objects[file_name].public_url
			end
		end
	end

	def upload(file_name)
		bucket = @s3.buckets[@bucket_name]
		puts ("Checking for bucket")
		if bucket.exists?
			# Upload a file.
			puts ("Uploading...")
			key = File.basename(file_name)
			puts ("Key: #{key}")
			bucket.objects[key].write(:file => file_name)
			puts ("Uploading file #{file_name} to bucket #{bucket}.")
		end
	end

end