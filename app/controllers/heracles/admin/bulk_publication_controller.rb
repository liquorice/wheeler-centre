module Heracles
  module Admin
    class BulkPublicationController < Heracles::Admin::ApplicationController
      helper SearchesHelper

      def index
        if params[:q]
          @search = query params, 40
          @facets = @search.facet(:page_type).rows
        end
      end

      def create
        search = query params, 100
        search.results.size
      end

    private

      def query(params, per_page)
        tags = params[:q].split(",")

        Sunspot.search(Heracles::Site.first.page_classes) do
          with :tags, tags
          with :published, true
          with :site_id, current_site.id
          order_by :created_at, :desc
          facet :page_type
          paginate page: params[:page] || 1, per_page: per_page
        end
      end

    end
  end
end
