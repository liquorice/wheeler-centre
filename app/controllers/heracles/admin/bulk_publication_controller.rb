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
            redirect_to actions_site_bulk_publication_index_path(current_site), flash: {success: "Status of selected records will be changed to #{status}ed very soon..."}
          end
        else
          redirect_to :back, flash: {alert: "Query parameter must be defined"}
        end
      end

      def actions
        @actions    = BulkPublicationAction.where("site_id = ? AND user_id = ?", current_site.id, current_user.id).order("id DESC")
        @completed  = @actions.select{ |job| job.completed_at.present? }.size
        @inprogress = @actions.select{ |job| job.completed_at.nil? }.size
      end

    private

      def query_defined?
        true if params[:q] && params[:q].present?
      end

    end
  end
end
