module HeraclesAdminAuthenticationHelpers
  def self.included(receiver)
    receiver.send :helper_method, :heracles_admin_login_path
    receiver.send :helper_method, :heracles_admin_logout_path
    receiver.send :helper_method, :heracles_admin_logout_path_method
    receiver.send :helper_method, :heracles_admin_current_user
  end

  def heracles_admin_current_user
    current_user
  end

  def heracles_admin_login_path
    main_app.new_user_session_path
  end

  def heracles_admin_logout_path
    main_app.destroy_user_session_path
  end

  def heracles_admin_logout_path_method
    :delete
  end
end

ApplicationController.send :include, HeraclesAdminAuthenticationHelpers
Heracles::Admin::ApplicationController.send :include, HeraclesAdminAuthenticationHelpers
