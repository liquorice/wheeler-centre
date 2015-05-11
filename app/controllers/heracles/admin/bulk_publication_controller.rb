module Heracles
  module Admin
    class BulkPublicationController < Heracles::Admin::ApplicationController
      helper SearchesHelper
      include ActionView::Helpers::TextHelper

      def index
        if query_defined?
          @search = sunpot_query params, 40
          @facets = @search.facet(:page_type).rows
        end
      end

      def create
        if query_defined?
          # Get all available records count (otherwise Sunspot returns only 40 per page)
          total_records = Heracles::Site.first.page_classes.map{ |item| item.all.count }.inject(:+)
          # Feed total records size to Sunspot
          total_search = sunpot_query(params, total_records).results
          # Change published status
          total_search.each{ |record| record.update(published: params.has_key?(:publish) ? true : false) } if total_search.size > 0
          # Redirect
          redirect_to :back, flash: {success: "Status changed for #{pluralize(total_search.size, "record")}"}
        else
          redirect_to :back, flash: {alert: "Query parameter must be defined"}
        end
      end

    private

      def query_defined?
        true if params[:q] && params[:q].present?
      end

      def sunpot_query(params, per_page)
        tags = params[:q].split(",")

        Sunspot.search(Heracles::Site.first.page_classes) do
          with :tags, tags
          with :site_id, current_site.id
          order_by :created_at, :desc
          facet :page_type
          paginate page: params[:page] || 1, per_page: per_page
        end
      end

    end
  end
end
