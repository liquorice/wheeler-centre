Rails.application.config.heracles_admin_host               = ENV["ADMIN_HOST"]
Rails.application.config.heracles_transloadit_auth_key     = ENV["TRANSLOADIT_AUTH_KEY"]
Rails.application.config.heracles_transloadit_auth_secret  = ENV["TRANSLOADIT_AUTH_SECRET"]
Rails.application.config.heracles_transloadit_template_id  = ENV["TRANSLOADIT_TEMPLATE_ID"]
Rails.application.config.heracles_embedly_api_key          = ENV["EMBEDLY_API_KEY"]

Rails.application.config.to_prepare do
  Heracles::Admin::ApplicationController.descendants.each do |controller|
    controller.helper ::ApplicationHelper
  end
end
