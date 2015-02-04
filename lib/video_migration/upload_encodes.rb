#!/usr/bin/ruby

# Utility script to upload audio and video encode files to an s3 bucket

require "./s3_util"

def file_exists_at_url(url)
  uri = URI.parse(url)
  request = Net::HTTP.new uri.host
  response = request.request_head uri.path
  return response.code.to_i == 200
end

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

  if !file_exists_at_url(audio_file_url)
    audio_file_url = "https://s3.amazonaws.com/video.wheelercentre.com/#{audio_file_name}"
  end

  video_uri = URI.parse(video_file_url)
  video_file_name = File.basename(video_uri.path)

  if !file_exists_at_url(video_file_url)
    video_file_url = "https://s3.amazonaws.com/video.wheelercentre.com/#{video_file_name}"
  end

  if audio_file_url
    unless s3.find(audio_file_name)
      unless File.file?(audio_file_name)
        system("wget #{audio_file_url}")
      end
      sleep 1
      s3.upload(audio_file_name)
    end
  end

  if video_file_url
    unless s3.find(video_file_name)
      unless File.file?(video_file_name)
        system("wget #{video_file_url}")
      end
      sleep 1
      s3.upload(video_file_name)
    end
  end
end

