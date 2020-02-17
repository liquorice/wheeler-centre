module Heracles
  module Admin
    module AdminApiResponder
      protected

      def api_behavior(error)
        if post?
          render action: :show, status: :created
        elsif put? || patch?
          render action: :show, status: :ok
        else
          super
        end
      end
    end
  end
end
