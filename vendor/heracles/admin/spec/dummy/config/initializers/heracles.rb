Rails.application.config.heracles_transloadit_auth_key = "xxx"
Rails.application.config.heracles_transloadit_auth_secret = "xxx"
Rails.application.config.heracles_transloadit_template_id = "123"

Rails.application.config.to_prepare do
  require_dependency "heracles/admin_authentication_helpers"
end
