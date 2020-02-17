require "heracles-core"

# Backend
require "api-pagination"
require "decent_exposure"
require "interactor"
require "jbuilder"
require "kaminari"
require "responders"
require "slim-rails"
require "aws-sdk"

# Frontend
require "autoprefixer-rails"
require "bourbon"
require "coffee-rails"
require "font-awesome-rails"
require "nestive"
require "react-rails"
require "sass-rails"
require "turbolinks"

# Assets
require "rails-assets-fastclick"
require "rails-assets-filament-sticky"
require "rails-assets-html5shiv"
require "rails-assets-jquery"
require "rails-assets-jquery-timepicker-jt"
require "rails-assets-jquery-ujs-standalone"
require "rails-assets-jstimezonedetect"
require "rails-assets-lodash"
require "rails-assets-nprogress"
require "rails-assets-momentjs"
require "rails-assets-pikaday"
require "rails-assets-react-radio-group"
require "rails-assets-select2"
require "rails-assets-selectivizr"
require "rails-assets-speakingurl"
require "rails-assets-viewloader"

require "heracles/admin/engine"
require "heracles/admin/admin_host_constraint"
require "heracles/admin/admin_responder"
require "heracles/admin/policy_parameters_strategy"
require "heracles/admin/resourceful_flash_setter"

module Heracles::Admin
end
