module Heracles
  module Admin
    class BulkPublicationController < Heracles::Admin::ApplicationController
      include BulkPublicationSearch
      include ActionView::Helpers::TextHelper
      helper SearchesHelper

      before_filter :check_processing_queue, only: :index

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
            session[:in_progress_actions_ids] = BulkPublicationAction.in_progress(current_site.id, current_user.id).pluck(:id)
            BulkPublicationJob.enqueue action.id
            redirect_to :back
          end
        else
          redirect_to :back, flash: {alert: "Query parameter must be defined"}
        end
      end

    private

    def query_defined?
      params[:q].present?
    end

    def check_processing_queue
      @in_progress = BulkPublicationAction.in_progress(current_site.id, current_user.id)

      if session[:in_progress_actions_ids]
        in_progress_actions               = @in_progress.pluck(:id)
        processed_actions                 = session[:in_progress_actions_ids] - in_progress_actions
        session[:in_progress_actions_ids] = in_progress_actions

        BulkPublicationAction.where("id IN (?)", processed_actions).each do |item|
          flash.now[:success] = "Bulk action ##{item.id} (#{item.action} items tagged as #{item.readable_tags}) has been succesfully processed!"
        end
      end
    end

    end
  end
end
