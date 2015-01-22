module Heracles
  module Admin
    module Api
      module Fields

        class ExternalVideoController < Heracles::Admin::ApplicationController
          def show
            render json: {id: params[:id]}
          end
        end

      end
    end
  end
end
