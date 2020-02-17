module Heracles
  module SiteController
    extend ActiveSupport::Concern

    included do
      helper_method :site
    end

    def site
      # "heracles.site" is populated by SiteHostConstraint
      @site ||= request.env["heracles.site"].presence or raise ActiveRecord::RecordNotFound
    end
  end
end
