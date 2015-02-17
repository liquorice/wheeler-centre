class PagesController < ApplicationController
  include Heracles::PublicPagesController
  include ApplicationHelper

  before_filter :set_page_meta_tags, only: [:show]
  before_filter :set_cache_headers_for_page, only: [:show]

  protected

  def set_cache_headers_for_page
    response.headers["Surrogate-Key"] = page.cache_key
    headers.delete 'Set-Cookie'
  end

  def set_page_meta_tags
    set_meta_tags title: markdown_line(page.title),
                  og: {
                    title: markdown_line(page.title),
                    url:   url_with_domain(page.absolute_url)
                  },
                  canonical: url_with_domain(page.absolute_url),
                  description: I18n.t("metadata.description"),
                  keywords: I18n.t("metadata.keywords")
  end
end
