module Heracles
  module Admin
    class EventsExportController < Heracles::Admin::ApplicationController

      def index
      end

      def create
        EventsExportJob.enqueue(site.id, params[:email])
        redirect_to :back, flash: {success: "Export started. You’ll receive an email at #{params[:email]} soon."}
      end
    end
  end
end
