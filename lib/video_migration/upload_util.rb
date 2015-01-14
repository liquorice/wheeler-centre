require "aws-sdk"
require "yaml"
require "net/scp"

class UploadUtil
	attr_accessor :config_file

	def initialize(args)
		args.each do |key, value|
      instance_variable_set("@#{key}", value)
    end

    opts = YAML.load_file(@config_file)

		AWS.config(
		  :access_key_id => opts["MIGRATION_AWS_ACCESS_KEY_ID"],
		  :secret_access_key => opts["MIGRATION_AWS_SECRET_KEY"],
		  :region => "ap-southeast-2")

		# the role, policy and profile all have names, pick something descriptive
		role_name = "s3-read-only"
		policy_name = "s3-read-only"
		@instance_profile_name = "ec3-s3-read-only"
		key_name = "wheeler-centre-video-migration"
		path = "/Users/josephinehall/Development/wheeler-centre/lib/video_migration"

		# required so that Amazon EC2 can generate session credentials on your behalf
		assume_role_policy_document = '{"Version":"2008-10-17","Statement":[{"Effect":"Allow","Principal":{"Service":["ec2.amazonaws.com"]},"Action":["sts:AssumeRole"]}]}'

		# build a custom policy
		policy = AWS::IAM::Policy.new
		policy.allow(:actions => ["s3:Get*","s3:List*"], :resources => '*')

		iam = AWS::IAM.new

		unless iam.client.get_role(:role_name => role_name)
			# create the role
			iam.client.create_role(
			  :role_name => role_name,
			  :assume_role_policy_document => assume_role_policy_document)

			# add the policy to role
			iam.client.put_role_policy(
			  :role_name => role_name,
			  :policy_name => policy_name,
			  :policy_document => policy.to_json)
		end

		unless iam.client.get_instance_profile(:instance_profile_name => @instance_profile_name)
			iam.client.create_instance_profile(
		  :instance_profile_name => @instance_profile_name)

			iam.client.add_role_to_instance_profile(
			  :instance_profile_name => @instance_profile_name,
			  :role_name => role_name)
		end

		@ec2 = AWS::EC2.new

		@key_pair = @ec2.key_pairs.create(key_name)
		File.open("#{path}/#{key_name}.pem", "wb") {|f| f.write(@key_pair.private_key) }
		@private_key = "#{path}/#{key_name}.pem"

		list_instances
	end

	def sync_s3_file
		# Create an instance
		instance = @ec2.instances.create(
			:image_id => 'ami-71f7954b',
			:iam_instance_profile => @instance_profile_name)

		# scp the script to the instance
		Net::SCP.start(instance.dns_name, "ec2-user", :keys => @private_key ) do |scp|
      scp.upload!("#{path}/upload_file.sh", "~", :ssh => @private_key)
    end

		# # run the script

	end

	def stop_instances
		@ec2.instances.each do |instance|
			if instance.status_code == 16 then instance.stop end
		end
	end

	def delete_instances
		@ec2.instances.each do |instance|
			instance.terminate
		end
	end

	def list_instances
		instances = @ec2.instances.inject({}) { |m, i| m[i.id] = i.status; m }
		puts (instances)
	end

end

