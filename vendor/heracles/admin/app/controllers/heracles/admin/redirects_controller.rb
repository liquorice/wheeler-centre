module Heracles
  module Admin
    class RedirectsController < ApplicationController
      expose(:redirects) { site.redirects }
      expose(:redirect)
    end
  end
end
