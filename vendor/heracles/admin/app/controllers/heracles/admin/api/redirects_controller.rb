module Heracles
  module Admin
    module Api
      class RedirectsController < Heracles::Admin::ApplicationController
        ### Behaviors

        wrap_parameters Heracles::Redirect, include: [:redirect_order_position, :source_url, :target_url]

        respond_to :json

        ### Exposures

        expose(:redirects, ancestor: :site, model: "heracles/redirect")
        expose(:redirect, model: "heracles/redirect", attributes: :redirect_params)

        ### Actions

        def create
          redirect.save
          respond_with redirect, location: (api_site_redirect_path(id: redirect) if redirect.id)
        end

        def update
          redirect.save
          respond_with redirect, location: api_site_redirect_path(id: redirect)
        end

        def destroy
          redirect.destroy
          respond_with redirect, location: api_site_redirect_path(id: redirect)
        end

        private

        def redirect_params
          params.fetch(:redirect, {}).permit(
            :redirect_order_position,
            :source_url,
            :target_url)
        end
      end
    end
  end
end
