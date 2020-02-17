module Heracles
  module AdminUserAuth
    module AdminAuthenticationHelpers
      def self.included(base)
        base.send :helper_method, :heracles_admin_login_path
        base.send :helper_method, :heracles_admin_logout_path
        base.send :helper_method, :heracles_admin_logout_path_method
        base.send :helper_method, :heracles_admin_current_user
      end

      def heracles_admin_current_user
        current_user
      end

      def heracles_admin_login_path
        heracles_admin.new_user_session_path
      end

      def heracles_admin_logout_path
        heracles_admin.destroy_user_session_path
      end

      def heracles_admin_logout_path_method
        :get
      end
    end
  end
end
