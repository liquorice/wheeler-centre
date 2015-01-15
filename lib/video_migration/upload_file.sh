#!/bin/bash
sudo yum update
# yes
curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
sudo python get-pip.py

sudo pip install awscli


pip install --upgrade google-api-python-client

wget https://github.com/tokland/youtube-upload/archive/master.zip
unzip master.zip
cd youtube-upload-master
sudo python setup.py install
cd ~

aws s3 sync s3://video.wheelercentre.com/52499_31164_39bb473a52976cddf8778091b17cfda75f4c334b_31164.mp4 ~/video

FILE=~/video/52499_31164_39bb473a52976cddf8778091b17cfda75f4c334b_31164.mp4
TITLE="title"
CATEGORY="category"
DESCRIPTION="description"
KEYWORDS="keywords"

YOUTUBEEMAIL=josephinehall@gmail.com
YOUTUBEPASS=BlcifTotboaT

youtube-upload --email=$YOUTUBEEMAIL --password=$YOUTUBEPASS  FILE --unlisted --title=$TITLE --category=$CATEGORY --description=$DESCRIPTION --keywords=$KEYWORDS "Processing file"
