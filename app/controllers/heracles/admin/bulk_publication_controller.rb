module Heracles
  module Admin
    class BulkPublicationController < Heracles::Admin::ApplicationController
      include BulkPublicationSearch
      include ActionView::Helpers::TextHelper
      helper SearchesHelper

      def index
        if query_defined?
          @search = sunpot_query params, current_site.id, 40
          @facets = @search.facet(:page_type).rows
        end
      end

      def create
        if query_defined?
          status = params.has_key?(:publish) ? "publish" : "unpublish"

          action = BulkPublicationAction.new(
            user_id: current_user.id,
            site_id: current_site.id,
            tags: params[:q],
            action: status
          )

          if action.save
            BulkPublicationJob.enqueue action.id
            redirect_to :back, flash: {success: "Status of selected records will be changed to #{status}ed very soon..."}
          end
        else
          redirect_to :back, flash: {alert: "Query parameter must be defined"}
        end
      end

    private

      def query_defined?
        true if params[:q] && params[:q].present?
      end

    end
  end
end
