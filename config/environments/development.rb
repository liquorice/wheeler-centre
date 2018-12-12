Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.perform_deliveries = true

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = false

  # Add everything in our custom lib/src/tmp assets directory to the precompiled list
  config.assets.precompile += Dir["lib/src/tmp/**/*.*"].reject {|f| f =~ /^lib\/src\/tmp\/components/}.collect {|f| f.gsub(/^lib\/src\/tmp\//, "")}

  # Add a bunch of heracles stuff
  config.assets.precompile += %w( fontawesome-webfont.otf fontawesome-webfont.ttf fontawesome-webfont.svg fontawesome-webfont.eot fontawesome-webfont.woff )
  config.assets.precompile += [
    "fontawesome-webfont.otf",
    "fontawesome-webfont.ttf",
    "fontawesome-webfont.svg",
    "fontawesome-webfont.eot",
    "fontawesome-webfont.woff",
    "heracles/admin/lyon-text/LyonText-Bold.eot",
    "heracles/admin/lyon-text/LyonText-Bold.woff",
    "heracles/admin/lyon-text/LyonText-BoldItalic.eot",
    "heracles/admin/lyon-text/LyonText-BoldItalic.woff",
    "heracles/admin/lyon-text/LyonText-Regular.eot",
    "heracles/admin/lyon-text/LyonText-Regular.woff",
    "heracles/admin/lyon-text/LyonText-RegularItalic.eot",
    "heracles/admin/lyon-text/LyonText-RegularItalic.woff",
    "heracles/admin/lyon-text/LyonText-Bold.svg",
    "heracles/admin/lyon-text/LyonText-BoldItalic.svg",
    "heracles/admin/lyon-text/LyonText-Regular.svg",
    "heracles/admin/lyon-text/LyonText-RegularItalic.svg",
    "heracles/admin/lyon-text/LyonText-Bold.ttf",
    "heracles/admin/lyon-text/LyonText-BoldItalic.ttf",
    "heracles/admin/lyon-text/LyonText-Regular.ttf",
    "heracles/admin/lyon-text/LyonText-RegularItalic.ttf",
    "heracles/admin/larsseit/Larsseit-Medium.eot",
    "heracles/admin/larsseit/Larsseit-Medium.woff",
    "heracles/admin/larsseit/Larsseit.eot",
    "heracles/admin/larsseit/Larsseit.woff",
    "heracles/admin/larsseit/Larsseit-Medium.svg",
    "heracles/admin/larsseit/Larsseit.svg",
    "heracles/admin/larsseit/Larsseit-Medium.ttf",
    "heracles/admin/larsseit/Larsseit.ttf",
    "heracles/select2-spinner.gif",
    "heracles/select2.png",
    "heracles/select2x2.png"
  ]

  # Use custom asset_host for development
  config.action_controller.asset_host = "#{ENV['ASSETS_DEVELOPMENT_HOST']}:#{ENV['ASSETS_DEVELOPMENT_PORT']}"

  config.assets.precompile += Dir["assets/build/**/*.*"]

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  config.action_mailer.default_url_options = { host: 'localhost', port: 5000 }
end
