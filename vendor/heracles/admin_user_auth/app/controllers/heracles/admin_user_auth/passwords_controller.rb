module Heracles
  module AdminUserAuth
    class PasswordsController < ::Devise::PasswordsController
      skip_before_filter :authenticate_heracles_admin_user
    end
  end
end
