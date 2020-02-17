module Heracles
  module Admin
    class PageTypesController < ApplicationController
      self.policy_class = PagePolicy

      respond_to :html

      expose(:page) { site.pages.find(params[:page_id]) }

      def update
        authorize page, :change_page_type?

        new_page = page.to_page_type!(page_type_params[:type])
        respond_with new_page, location: edit_site_page_path(site, new_page)
      end

      private

      def page_type_params
        params.require(:page_type).permit(:type)
      end
    end
  end
end
