module Heracles
  module Admin
    class ContentExportController < Heracles::Admin::ApplicationController

      def index
      end

      def create
        ContentExportJob.enqueue(site.id, params[:email])
        redirect_to :back, flash: {success: "Export started. You’ll receive an email at #{params[:email]} soon."}
      end
    end
  end
end
