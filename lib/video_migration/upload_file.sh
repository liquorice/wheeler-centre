#!/bin/bash
sudo pip install awscli
aws s3 sync s3://video.wheelercentre.com/52499_31164_39bb473a52976cddf8778091b17cfda75f4c334b_31164.mp4 ~/video

wget https://github.com/tokland/youtube-upload/archive/master.zip
unzip master.zip
cd youtube-upload-master
sudo python setup.py install

FILE=~/video/52499_31164_39bb473a52976cddf8778091b17cfda75f4c334b_31164.mp4
TITLE="title"
CATEGORY="category"
DESCRIPTION="description"
KEYWORDS="keywords"

YOUTUBEEMAIL=josephinehall@gmail.com
YOUTUBEPASS=BlcifTotboaT

echo "Processing file"
youtube-upload --email=$YOUTUBEEMAIL --password=$YOUTUBEPASS  FILE --unlisted --title=$TITLE --category=$CATEGORY --description=$DESCRIPTION --keywords=$KEYWORDS