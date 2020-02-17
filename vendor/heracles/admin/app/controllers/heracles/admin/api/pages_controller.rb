module Heracles
  module Admin
    module Api
      class PagesController < Heracles::Admin::ApplicationController
        ### Behaviors

        wrap_parameters Heracles::Page, include: [:page_order_position]

        respond_to :json

        ### Actions

        def index
          @pages = paginate(find_pages)
          @more = @pages.count > 0
        end

        def show
          @page = site.pages.find(params[:id])
        end

        def update
          @page = site.pages.find(params[:id])
          @page.update_attributes(page_params)
          respond_with @page
        end

        private

        def find_pages
          params[:q].present? ? search_pages : query_pages
        end

        def find_page_by_parent_url
          site.pages.find_by_url(params[:page_parent_url])
        end

        def search_pages
          pages = filtered_pages(
            site.pages
          ).search_by_title_and_tag(
            params[:q]
          )
          paginate pages, page: params[:page].presence || 1, per_page: params[:per_page].presence || 20
        end

        def query_pages
          per_page = params[:per_page].presence || 20

          if params[:page_ids].present?
            page_ids = params[:page_ids].split(",")
            pages    = site.pages.where(id: page_ids)
            per_page = page_ids.length
          else
            pages = site.pages
          end

          filtered_pages(pages).page(params[:page]).per(per_page)
        end

        def filtered_pages(pages)
          params[:parent_id] ||= find_page_by_parent_url.try(:id) if params[:page_parent_url].present?
          pages = pages.children_of(params[:parent_id])           if params[:parent_id].present?
          pages = pages.of_type(params[:page_type])               if params[:page_type].present?
          pages.reorder("updated_at DESC, created_at DESC")
        end

        def page_params
          params.require(:page).permit(:page_order_position)
        end
      end
    end
  end
end
