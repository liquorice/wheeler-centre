# Usage
# ec2 = EC2Util.new(config_file: "/Users/josephinehall/Development/wheeler-centre/lib/video_migration/config.yml") 

require "aws-sdk"
require "yaml"
require "net/scp"
require "nokogiri"

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
		@instance_profile_name = "s3-read-only"
		@key_name = "wheeler-centre-video-migration"
		@path = "/Users/josephinehall/Development/wheeler-centre/lib/video_migration"
		@security_group_name = "wheeler-centre-video-migration"

		# required so that Amazon EC2 can generate session credentials on your behalf
		assume_role_policy_document = '{"Version":"2008-10-17","Statement":[{"Effect":"Allow","Principal":{"Service":["ec2.amazonaws.com"]},"Action":["sts:AssumeRole"]}]}'

		# build a custom policy
		policy = AWS::IAM::Policy.new
		policy.allow(:actions => ["s3:*"], :resources => '*')

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
		unless security_group
			security_group = @ec2.security_groups.create(@security_group_name)
			security_group.authorize_ingress(:tcp, 22)
		end

		@instances = {}
		list_instances
	end

	def create_instances(number_of_instances)
		number_of_instances.times do |i|
			create_instance(i)
		end
		puts ("Sleeping for 120")
		sleep 120

		@instances.each_with_index do |instance, index|
			instance = @ec2.instances[@instances[index]]

			while instance.status == :pending
				puts ("Sleeping for a bit")
				sleep 10
			end

			if instance.status == :running
				Net::SSH.start(instance.dns_name, "ec2-user", :keys => @private_key) do |ssh|
					# capture all stderr and stdout output from a remote process
					output = ssh.exec!("hostname")
					ssh.open_channel do |channel|
						channel.request_pty do |c, success|
							raise "could not request pty" unless success
					    if success
					      command = "sudo yum install ruby-devel"
					      c.exec(command)
					    end

							channel.on_data do |ch, data|
					      # puts "got stdout: #{data}"
					      channel.send_data "yes\n"
					    end

					    channel.on_extended_data do |ch, type, data|
					      puts "got stderr: #{data}"
					    end

					    channel.on_close do |ch|
					      puts "channel is closing!"
		    			end
					  end
					end
					ssh.open_channel do |channel|
						channel.request_pty do |c, success|
							raise "could not request pty" unless success
					    if success
					      command = 'sudo yum groupinstall "Development Tools"'
					      c.exec(command)
					    end

							channel.on_data do |ch, data|
					      # puts "got stdout: #{data}"
					      channel.send_data "yes\n"
					    end

					    channel.on_extended_data do |ch, type, data|
					      puts "got stderr: #{data}"
					    end

					    channel.on_close do |ch|
					      puts "channel is closing!"
		    			end
					  end
					end

					# Install gems
					ssh.exec("gem install google-api-client")
					ssh.exec("gem install trollop")
					ssh.exec("gem install thin")
					ssh.exec("gem install launchy")

					puts ("Finished setup")

				end
			end
		end
	end

	def create_instance(index)
		instance = @ec2.instances.create(
			:image_id => 'ami-71f7954b',
			:iam_instance_profile => @instance_profile_name,
			:security_groups => @security_group_name,
			:key_pair => @ec2.key_pairs[@key_name])

		@instances[index] = instance.id
		puts ("Created instance")
	end

	def get_instances(number_of_instances)
		running_instances = @ec2.instances.select{ |instance| instance.status == :running }
		puts (running_instances)
		running_instances.each_with_index do |instance, index|
			@instances[index] = instance.id
		end

	end

	def create_scripts(index, file_name, public_url, recording)
		# Make a directory for this instance
		Dir.mkdir("#{@path}/migrations/#{index}")

		# Strip HTML from the description
		description = Nokogiri::HTML(recording.fields[:description].value).text

		# create video_data.json
		File.open("#{@path}/migrations/#{index}/video_data.json", "w", 0600) do |file|
			json = JSON.dump({
				:file_path => file_name,
				:title => recording.title,
				:description => description,
				:category_id => "22", # People and blog category
				:keywords => "Ideas, Melbourne, Australia, Conversation, The Wheeler Centre, Victoria, Writing",
				:privacy_status => "public"
				# :recording_date => recording.fields[:recording_date].value.iso8601
				})
			file.write(json)
		end

		unless public_url
			public_url = "http://download.wheelercentre.com/#{file_name}"
		end

		script = """
			# Fetch the asset
			wget #{public_url}
			# Run the video migration
			ruby video_migration_util.rb
		"""

		File.open("#{@path}/migrations/#{index}/installation.sh", "w", 0600) do |file|
			file.write(script)
		end

		puts ("Created scripts")

	end

	def transfer_scripts(index)
		instance = @ec2.instances[@instances[index]]
		puts ("Transferring scripts")
		puts (@instances)
		puts (instance)
		Net::SSH.start(instance.dns_name, "ec2-user", :keys => @private_key) do |ssh|
			ssh.scp.upload!("#{@path}/migrations/#{index}/installation.sh", ".", :ssh => @private_key )
			ssh.scp.upload!("#{@path}/video_migration_util.rb", ".", :ssh => @private_key)
			ssh.scp.upload!("#{@path}/oauth_util.rb", ".", :ssh => @private_key)
			ssh.scp.upload!("#{@path}/client_secrets.json", ".", :ssh => @private_key)
			ssh.scp.upload!("#{@path}/credentials_file.json", ".", :ssh => @private_key)
			ssh.scp.upload!("#{@path}/migrations/#{index}/video_data.json", ".", :ssh => @private_key)
			ssh.exec("rm -rf response_data.json")
			puts ("Uploaded all files")
		end
	end

	def execute_scripts(index)
		instance = @ec2.instances[@instances[index]]
		Net::SSH.start(instance.dns_name, "ec2-user", :keys => @private_key) do |ssh|
			# capture all stderr and stdout output from a remote process
			output = ssh.exec!("hostname")
			ssh.exec("bash installation.sh")
			puts (output)
		end
	end

	def get_youtube_id(index)
		instance = @ec2.instances[@instances[index]]
		response_data = "#{@path}/migrations/#{index}/response_data.json"

		Net::SCP.start(instance.dns_name, "ec2-user", :keys => @private_key) do |scp|
			scp.download!("./response_data.json", response_data, :ssh => @private_key)
		end

		if File.exist? response_data
			File.open(response_data, "r") do |file|
				data = JSON.load(file)
				puts (data["id"])
				data["id"]
			end
		end
	end

	def get_youtube_url(index)
		id = get_youtube_id(index)
		if id.present?
			"http://www.youtube.com/watch?v=" + id.to_s
		end
	end

	def terminate_instance(index)
		puts @instances[index]
		@ec2.instances[@instances[index]].terminate
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

