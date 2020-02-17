module Heracles
  module Sites
    module <%= camel_case_site_name %>
      class PagesController < ApplicationController
        include Heracles::PublicPagesController
      end
    end
  end
end
