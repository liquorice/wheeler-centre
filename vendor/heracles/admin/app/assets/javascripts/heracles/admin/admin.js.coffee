# Third-party dependencies come first:
#= require jquery
#= require jquery-ujs-standalone
#= require turbolinks
#= require viewloader

# Default options
#= require heracles/admin/utils/defaults

# Prequel
#= require_self

# These are dependents:
#= require heracles/admin/components/autoexpand
#= require heracles/admin/components/admin_controller
#= require heracles/admin/components/page_form_controller
#= require heracles/admin/components/redirects_controller
#= require heracles/admin/components/activate_preview
#= require heracles/admin/components/asset_uploader
#= require heracles/admin/components/field_addon
#= require heracles/admin/components/insertions_panel
#= require heracles/admin/components/helper_slugify
#= require heracles/admin/components/save_state_tracker
#= require heracles/admin/components/sticky
#= require heracles/admin/components/number_helpers
#= require heracles/admin/components/text_helpers
#= require heracles/admin/components/pages_selector
#= require heracles/admin/components/pages_actions

window.HeraclesAdmin = window.HeraclesAdmin || {}
window.HeraclesAdmin.components = window.HeraclesAdmin.components || {}
window.HeraclesAdmin.helpers = window.HeraclesAdmin.helpers || {}
window.HeraclesAdmin.views = window.HeraclesAdmin.views || {}

window.HeraclesAdmin.boot = ->
  window.HeraclesAdmin.options = $.extend {}, window.HeraclesAdmin.defaults, window.HeraclesAdmin.options
  viewloader.execute HeraclesAdmin.views
