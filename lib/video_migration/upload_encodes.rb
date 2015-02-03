#!/usr/bin/ruby

# Utility script to upload audio and video encode files to an s3 bucket

require "./s3_util"

s3 = S3Util.new(bucket_name: "wheeler-centre-heracles", config_file: "config.yml")
data = File.read("audio_video_encodes.yml")
audio_video_encodes = YAML.load(data)

audio_video_encodes.each do |encode|
  puts (encode)
  audio_file_url = encode["audio_encode_url"]
  video_file_url = encode["video_encode_url"]

  puts (audio_file_url)
  puts (video_file_url)

  audio_uri = URI.parse(audio_file_url)
  audio_file_name = File.basename(audio_uri.path)

  video_uri = URI.parse(video_file_url)
  video_file_name = File.basename(video_uri.path)

  if audio_file_url
    unless File.file?(audio_file_name)
      exec("wget #{audio_file_url}")
    end
    unless s3.find(audio_file_name)
      s3.upload(audio_file_name)
    end
  end

  if video_file_url
    unless File.file?(video_file_name)
      exec("wget #{video_file_url}")
    end
    unless s3.find(video_file_name)
      s3.upload(video_file_name)
    end
  end
end

