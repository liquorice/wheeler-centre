module Heracles
  module Admin
    class BulkPublicationController < Heracles::Admin::ApplicationController
      helper SearchesHelper

      def index
        if params[:q]
          tags         = params[:q].split(",")

          @search = Sunspot.search(Heracles::Site.first.page_classes) do
            with :tags, tags
            with :published, true
            with :site_id, current_site.id
            order_by :created_at, :desc
            paginate page: params[:page] || 1, per_page: 40
          end
        end
      end

    end
  end
end
