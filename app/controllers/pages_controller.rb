class PagesController < ApplicationController
  include Heracles::PublicPagesController
  include ApplicationHelper

  before_filter :set_page_meta_tags, only: [:show]

  def site
    @site ||= Heracles::Site.where(slug: HERACLES_SITE_SLUG).first!
  end

  protected

  def set_page_meta_tags
    set_meta_tags title: markdown_line(@page.title),
                  og: {
                    title: markdown_line(@page.title),
                    url:   "http://#{@site.hostnames.first}#{@page.absolute_url}"
                  }
  end
end
