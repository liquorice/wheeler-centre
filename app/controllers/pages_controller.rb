class PagesController < ApplicationController
  include Heracles::PublicPagesController
  include ApplicationHelper

  before_filter :set_page_meta_tags, only: [:show]
  before_filter :set_cache_headers_for_page, only: [:show]

  protected

  def set_cache_headers_for_page
    expires = request.format == :rss ? 1.hour.to_i : 1.day.to_i

    if Rails.env.production?
      response.headers["Surrogate-Control"] = "max-age=#{expires}"
      response.headers["Cache-Control"] = "max-age=300, public"
      response.headers["Surrogate-Key"] = page.cache_key
      # Remove "Set-Cookie" header
      request.session_options[:skip] = true
    end
  end

  def set_page_meta_tags
    set_meta_tags title: markdown_line(page.title),
                  og: {
                    site_name: I18n.t("metadata.site_name"),
                    type: I18n.t("metadata.type"),
                    title: markdown_line(page.title),
                    url:   url_with_domain(page.absolute_url),
                    updated_time: page.updated_at.iso8601
                  },
                  twitter: {
                    card: 'summary',
                    title: markdown_line(page.title),
                    site: '@wheelercentre'
                  },
                  canonical: url_with_domain(page.absolute_url),
                  description: I18n.t("metadata.description"),
                  keywords: I18n.t("metadata.keywords")
  end
end
