module Heracles
  module PublicPagesController
    extend ActiveSupport::Concern

    include Heracles::SiteController

    included do
      public_page_pattern = "{:prefix/,}{:public_page_type/:public_page_template,:public_page_type,:action}{.:locale,}{.:formats,}{.:handlers,}"
      view_paths.each do |path|
        prepend_view_path ActionView::FileSystemResolver.new(path.to_s, public_page_pattern)
      end

      helper_method :page, :previewing?

      before_filter :require_preview_token, only: :show
      prepend_before_filter :handle_redirect, only: :show
    end

    ### Actions

    def show
      page # Eagerly access the page, so we can raise RecordNotFound for missing pages
    end

    ### Accessors

    memoize \
    def page
      page = pages_scope.find_by_url!(params[:path].presence || "home")
      page.attributes = page_params if previewing?
      PublicPageDecorator.new(page)
    end

    def details_for_lookup
      super.merge public_page_type: [page.page_type], public_page_template: [page.template]
    rescue ActiveRecord::RecordNotFound
      super
    end

    private

    ### Private helpers

    def previewing?
      params[:preview].present?
    end

    def preview_permitted?
      params[:site_preview_token].present? && params[:site_preview_token] == site.preview_token
    end

    def pages_scope
      if previewing?
        site.pages
      else
        site.pages.published
      end
    end

    def handle_redirect
      if (redirect = site.redirects.where("lower(source_url) = ?", "/" + params[:path].to_s.downcase).first)
        redirect_to redirect.target_url, status: 301
      end
    end

    def require_preview_token
      raise ActiveRecord::RecordNotFound if previewing? && !preview_permitted?
    end

    def page_params
      params.fetch(:page, {}).permit!
    end
  end
end
