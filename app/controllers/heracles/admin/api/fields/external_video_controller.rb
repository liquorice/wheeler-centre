module Heracles
  module Admin
    module Api
      module Fields

        class ExternalVideoController < Heracles::Admin::ApplicationController
          def index
            field = Heracles::Sites::WheelerCentre::ExternalVideoField.new(value: params[:url])
            render json: field.fetch
          end
        end

      end
    end
  end
end
