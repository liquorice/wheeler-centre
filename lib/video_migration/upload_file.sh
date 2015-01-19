#!/bin/bash
sudo yum update
# yes
sudo pip install awscli


# Fetch the asset
aws s3 cp --region ap-southeast-2 s3://video.wheelercentre.com/52499_31164_39bb473a52976cddf8778091b17cfda75f4c334b_31164.mp4 ~/

# Install gems
gem install "google-api-client"
gem install "trollop"
gem install "thin"
gem install "launchy"

# Run the video migration
ruby video_migration_util.rb

