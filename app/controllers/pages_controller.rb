class PagesController < ApplicationController
  include Heracles::PublicPagesController

  def site
    @site ||= Heracles::Site.where(slug: HERACLES_SITE_SLUG).first!
  end
end
