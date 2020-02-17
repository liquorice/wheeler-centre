module Heracles
  module Admin
    class PagesController < ApplicationController
      self.policy_class = PagePolicy

      before_filter :find_page, except: [:index, :new, :create]
      before_filter :find_insertions, except: [:index, :new, :create]

      respond_to :html

      layout "heracles/admin/admin_form"

      ### Actions

      def index
        render layout: "heracles/admin/admin"
      end

      def new
        @page = Heracles::Page.new_for_site_and_page_type(site, params[:page_type]).tap do |page|
          page.parent = parent_page
        end
      end

      def create
        create_params = page_params.merge(
          parent: parent_page,
          # New pages at the root level go to the bottom. Otherwise, they go to the top.
          page_order_position: parent_page.blank? ? :last : :first
        )

        create_result = Heracles::CreatePage.call(
          site: site,
          page_type: params[:page_type],
          page_params: create_params,
          create_default_children: true)

        @page = create_result.page
        ResourcefulFlashSetter.call(self, @page)

        if create_result.success?
          redirect_to edit_site_page_path(site, @page)
        else
          render :new
        end
      end

      def update
        update_result = Heracles::UpdatePage.call(page: @page, page_params: page_params)
        ResourcefulFlashSetter.call(self, @page)

        if update_result.success?
          redirect_to edit_site_page_path(site, @page)
        else
          render :edit
        end
      end

      def destroy
        @page.destroy

        return_location = @page.parent ? edit_site_page_path(site, @page.parent, open_tree_nav: true) : site_pages_path(site)
        respond_with @page, location: return_location
      end

      ### Additional helpers

      helper_method \
      def page_type_policy_scope(scope)
        PageTypePolicy::Scope.new(policy_user, scope).resolve
      end

      protected

      def parent_page
        @parent_page ||= site.pages.find_by_id(params[:parent_id].presence)
      end

      def find_page
        @page = site.pages.find(params[:id])
      end

      def find_insertions
        @insertions = @page.persisted? ? Heracles::Insertion.for_inserted(@page) : Heracles::Insertion.none
      end

      def page_params
        params.require(:page).permit(*policy(@page).permitted_attributes)
      end
    end
  end
end
