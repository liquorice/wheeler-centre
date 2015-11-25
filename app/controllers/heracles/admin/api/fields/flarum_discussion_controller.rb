module Heracles
  module Admin
    module Api
      module Fields

        class FlarumDiscussionController < Heracles::Admin::ApplicationController
          def update
            page = Heracles::Page.find(params[:page_id])
            page.fields[:flarum_discussion_id].value = params[:id]
            page.save
            render json: [status: "OK"]
          end
        end

      end
    end
  end
end
