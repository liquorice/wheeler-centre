module Heracles
  module Admin
    module Api
      module Fields

        class ExternalVideoController < Heracles::Admin::ApplicationController
          def index
            regex = /youtube.com.*(?:\/|v=)([^&$]+)/
            id = params[:url].match(regex)[1]
            render json: {id: id}
          end
        end

      end
    end
  end
end
