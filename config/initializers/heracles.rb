Rails.application.config.heracles_admin_host               = ENV["ADMIN_HOST"]
Rails.application.config.heracles_transloadit_auth_key     = ENV["TRANSLOADIT_AUTH_KEY"]
Rails.application.config.heracles_transloadit_auth_secret  = ENV["TRANSLOADIT_AUTH_SECRET"]
Rails.application.config.heracles_transloadit_template_id  = ENV["TRANSLOADIT_TEMPLATE_ID"]
Rails.application.config.heracles_embedly_api_key          = ENV["EMBEDLY_API_KEY"]

Heracles.user_class = "User"

Rails.application.config.to_prepare do
  require_dependency "heracles_admin_authentication_helpers"
end
