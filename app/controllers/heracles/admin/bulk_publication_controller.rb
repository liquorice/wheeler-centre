module Heracles
  module Admin
    class BulkPublicationController < Heracles::Admin::ApplicationController
      helper SearchesHelper

      before_filter :assign_bulk_publication_actions_in_progress, only: :index
      before_filter :assign_bulk_publication_actions_completed, only: :index

      def index
        if query_defined?
          @search           = BulkPublicationSearch.new(tags: params[:q], site_id: current_site.id).results
          @paginated_search = @search.page(params[:page]).per(40)
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
            session[:in_progress_bulk_publication_action_ids] ||= []
            session[:in_progress_bulk_publication_action_ids] << action.id
            BulkPublicationJob.enqueue action.id
            redirect_to :back
          end
        else
          redirect_to :back, flash: {alert: "Please select some tags to search"}
        end
      end

      private

      def query_defined?
        params[:q].present?
      end

      def assign_bulk_publication_actions_in_progress
        @bulk_publication_actions_in_progress = BulkPublicationAction.in_progress(current_site.id, current_user.id)
      end

      def assign_bulk_publication_actions_completed
        # Find the IDs for publication actions that _used_ to be in-progress, but are now completed
        completed_ids = session[:in_progress_bulk_publication_action_ids] - @bulk_publication_actions_in_progress.map(&:id) if session[:in_progress_bulk_publication_action_ids]

        if completed_ids
          # Assign the completed bulk publication actions to the view, so we can display a "done" notice
          @bulk_publication_actions_completed = BulkPublicationAction.find(completed_ids)

          # Then remove them from the session
          session[:in_progress_bulk_publication_action_ids] -= completed_ids
        end
      end
    end
  end
end
