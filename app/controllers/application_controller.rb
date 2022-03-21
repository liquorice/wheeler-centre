class ApplicationController < ActionController::Base
  include Heracles::SiteController
  layout :set_layout

  RECAPTCHA_MINIMUM_SCORE = 0.5

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    main_app.admin_path
  end

  def verify_recaptcha?(token, recaptcha_action)
    secret_key = ENV['RECAPTCHA_SECRET_KEY']

    responce = HTTParty.get("https://www.google.com/recaptcha/api/siteverify?secret=#{ENV['RECAPTCHA_SECRET_KEY']}&response=#{token}")
    json = JSON.parse(responce.body)
    json['success'] && json['score'] > RECAPTCHA_MINIMUM_SCORE && json['action'] == recaptcha_action
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
    elsif request.path.match /^\/broadside/
      "broadside"
    elsif request.path.match /^\/tnew/
      "tnew"
    else
      "application"
    end
  end
end
