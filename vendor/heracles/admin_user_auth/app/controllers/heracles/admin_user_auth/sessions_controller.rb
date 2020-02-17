module Heracles
  module AdminUserAuth
    class SessionsController < ::Devise::SessionsController
      skip_before_filter :authenticate_heracles_admin_user, except: :destroy

      private

      # These URL helpers shouldn't need to be namespaced for the engine,
      # since we're already _in_ the engine here, but it seems necessary for
      # them to work properly (otherwise they refer to the root app).

      def signed_in_root_path(resource_or_scope)
        heracles_admin.root_path
      end

      def after_sign_out_path_for(resource_or_scope)
        heracles_admin.new_user_session_path
      end
    end
  end
end
