class ApplicationController < ActionController::Base
  include Heracles::SiteController
  layout :set_layout

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    main_app.admin_path
  end

  # Expose the site to all controllers in the application
  helper_method \
  def site
    @site ||= Heracles::Site.where(slug: HERACLES_SITE_SLUG).first!
  end

  private
  def set_layout
    if request.path.match /^\/thenextchapter/
      "next_chapter"
    else
      "application"
    end
  end
end
