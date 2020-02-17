module HeraclesAdminAuthenticationHelpers
  def self.included(receiver)
    receiver.send :helper_method, :heracles_admin_login_path
    receiver.send :helper_method, :heracles_admin_logout_path
    receiver.send :helper_method, :heracles_admin_current_user
  end

  def heracles_admin_current_user
    nil
  end

  def heracles_admin_login_path
    main_app.root_path
  end

  def heracles_admin_logout_path
    main_app.root_path
  end
end

ApplicationController.send :include, HeraclesAdminAuthenticationHelpers
Heracles::Admin::ApplicationController.send :include, HeraclesAdminAuthenticationHelpers
