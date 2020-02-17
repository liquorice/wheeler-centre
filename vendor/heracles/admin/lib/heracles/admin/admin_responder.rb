require "heracles/admin/admin_api_responder"

module Heracles
  module Admin
    class AdminResponder < ActionController::Responder
      include Responders::FlashResponder
      include AdminApiResponder
    end
  end
end
