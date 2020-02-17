module Heracles
  module Admin
    module AdminHostConstraint
      extend self

      def matches?(request)
        request.host == Heracles.configuration.admin_host
      end
    end
  end
end
