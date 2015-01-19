require "aws-sdk"
require "yaml"
require "net/scp"

class EC2Util
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

		role_name = "s3-read-only"
		policy_name = "s3-read-only"
		@instance_profile_name = "ec3-s3-read-only"
		@key_name = "wheeler-centre-video-migration"
		@path = "/Users/josephinehall/Development/wheeler-centre/lib/video_migration"
		@security_group_name = "wheeler-centre-video-migration"

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

		unless @ec2.key_pairs[@key_name].exists?
			@key_pair = @ec2.key_pairs.create(@key_name)
			File.open("#{@path}/#{@key_name}.pem", "wb") {|f| f.write(@key_pair.private_key) }
		end
		@private_key = "#{@path}/#{@key_name}.pem"

		security_group = @ec2.security_groups.filter("group-name", @security_group_name).first
		unless security_group.present?
			security_group = @ec2.security_groups.create(@security_group_name)
			security_group.authorize_ingress(:tcp, 22)
		end

		list_instances
	end

	def create_instance
		@instance = @ec2.instances.create(
			:image_id => 'ami-71f7954b',
			:iam_instance_profile => @instance_profile_name,
			:security_groups => @security_group_name,
			:key_pair => @ec2.key_pairs[@key_name])
		puts ("Created instance")
	end

	def create_scripts(file_name, public_url, blueprint_video)
		# create video_data.json
		File.open("#{@path}/video_data.json", "w", 0600) do |file|
			json = JSON.dump({
				:file_path => file_name,
				:title => blueprint_video["title"],
				:description => blueprint_video["description"], # TODO strip html
				:category_id => "25",
				:keywords => "keywords, go, here",
				:privacy_status => "public"
				})
			file.write(json)
			puts ("Created video_data.json")
		end
		# TODO create the bash script with the right s3 filenames
	end

	def transfer_scripts
		while @instance.status == :pending
			puts ("Sleeping for a bit")
			sleep 10
		end

		if @instance.status == :running
			sleep 100
			puts ("Transferring scripts")
			Net::SSH.start(@instance.dns_name, "ec2-user", :keys => @private_key) do |ssh|
				ssh.scp.upload!("#{@path}/upload_file.sh", ".", :ssh => @private_key )
				ssh.scp.upload!("#{@path}/video_migration_util.rb", ".", :ssh => @private_key)
				ssh.scp.upload!("#{@path}/oauth_util.rb", ".", :ssh => @private_key)
				ssh.scp.upload!("#{@path}/client_secrets.json", ".", :ssh => @private_key)
				ssh.scp.upload!("#{@path}/credentials_file.json", ".", :ssh => @private_key)
				ssh.scp.upload!("#{@path}/video_data.json", ".", :ssh => @private_key)
				puts ("Uploaded all files")
			end
		end
	end

	def execute_scripts
		Net::SSH.start(@instance.dns_name, "ec2-user", :keys => @private_key) do |ssh|
			# capture all stderr and stdout output from a remote process
			output = ssh.exec!("hostname")
			ssh.exec "bash upload_file.sh"
			puts (output)
		end
	end

	def get_youtube_id
		response_data = "#{@path}/response_data.json"
		Net::SCP.start(@instance.dns_name, "ec2-user", :keys => @private_key) do |scp|
			scp.download!("~/response_data.json", response_data, :ssh => @private_key)
		end

		if File.exist? response_data
			File.open(response_data, "r") do |file|
				data = JSON.load(file)
				puts (data["videos"]["id"])
				data["videos"]["id"]
			end
		end
	end

	def get_youtube_url
		id = get_youtube_id
		if id.present?
			"http://www.youtube.com/watch?v=" + id.to_s
		end
	end

	def terminate_instance
		@instance.terminate
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

