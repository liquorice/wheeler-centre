#!/bin/bash
sudo yum update
# yes
sudo pip install awscli

aws s3 sync s3://video.wheelercentre.com/52499_31164_39bb473a52976cddf8778091b17cfda75f4c334b_31164.mp4 ~/video

# install gems
# run the following
# require video_migration_util
# video_migration_util = VideoMigrationUtil.new
# video_migration_util.upload_video(file_name, blueprint_video_post)