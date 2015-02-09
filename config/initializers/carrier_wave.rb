if %w(REGION BUCKET ACCESS_KEY_ID SECRET_ACCESS_KEY).all? { |k| ENV["ASSETS_AWS_#{k}"].present? }
  CarrierWave.configure do |config|
    config.storage = :fog
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => ENV["ASSETS_AWS_ACCESS_KEY_ID"],
      :aws_secret_access_key  => ENV["ASSETS_AWS_SECRET_ACCESS_KEY"],
      :region                 => ENV["ASSETS_AWS_REGION"]
    }
    config.fog_directory  = ENV["ASSETS_AWS_BUCKET"]
    config.fog_public     = true
    config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
  end
end