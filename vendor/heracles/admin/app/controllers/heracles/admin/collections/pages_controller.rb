module Heracles
  module Admin
    module Collections
      class PagesController < ApplicationController
        self.policy_class = PagePolicy

        before_filter :find_collection
        before_filter :find_page, except: [:index, :new, :create]
        before_filter :find_insertions, except: [:index, :new, :create]

        respond_to :html

        layout "heracles/admin/admin_form"

        ### Actions

        def index
          @pages = load_pages
        end

        def new
          @page = Heracles::Page.new_for_site_and_page_type(site, @collection.contained_page_type.to_str).tap do |page|
            page.parent = parent_page
          end
        end

        def create
          create_params = page_params.merge(
            parent: parent_page,
            collection: @collection)

          create_result = Heracles::CreatePage.call(
            site: site,
            page_type: @collection.contained_page_type.to_str,
            page_params: create_params,
            create_default_children: false)

          @page = create_result.page
          ResourcefulFlashSetter.call(self, @page)

          if create_result.success?
            redirect_to edit_site_collection_page_path(collection_id: @collection, id: @page)
          else
            render :new
          end
        end

        def update
          update_result = Heracles::UpdatePage.call(page: @page, page_params: page_params)
          ResourcefulFlashSetter.call(self, @page)

          if update_result.success?
            redirect_to edit_site_collection_page_path(collection_id: @collection, id: @page)
          else
            render :edit
          end
        end

        def destroy
          @page.destroy
          respond_with @collection, @page, location: site_collection_pages_path(collection_id: @collection)
        end

        ### Additional helpers

        helper_method \
        def page_type_policy_scope(scope)
          PageTypePolicy::Scope.new(policy_user, scope).resolve
        end

        private

        def parent_page
          @collection.parent or raise ActiveRecord::RecordNotFound
        end

        def find_collection
          @collection = site.pages.find(params[:collection_id])
        end

        def find_page
          @page = site.pages.find(params[:id])
        end

        def find_insertions
          @insertions = Heracles::Insertion.for_inserted(@page)
        end

        def load_pages
          if params[:q].present?
            search_pages(page: params[:page], per_page: params[:per_page])
          else
            @collection.pages.page(params[:page]).per(params[:per_page].presence || 20)
          end
        end

        def search_pages(options={})
          collections = Heracles::Page.where("site_id = ? AND collection_id = ?", @collection.site.id, @collection.id)
          collections = collections.search_by_title_and_tag(params[:q])
          paginate collections, page: options[:page].presence || 1, per_page: options[:per_page].presence || 20
        end

        def page_params
          params.require(:page).permit(*policy(@page).permitted_attributes)
        end
      end
    end
  end
end
