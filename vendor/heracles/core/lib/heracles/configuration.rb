module Heracles
  class Configuration
    attr_accessor :admin_host
    attr_accessor :embedly_api_key

    def asset_processing_notification_url(params={})
      Heracles::Admin::Engine.routes.url_helpers.asset_processing_notifications_url({host: admin_host}.merge(params))
    end
  end

  # Public: Returns the current global configuration.
  def self.configuration
    @configuration ||= Configuration.new
  end

  # Public: Set the global configuration.
  def self.configuration=(new_configuration)
    @configuration = new_configuration
  end

  # Public: Modify the current global configuration.
  #
  # Yields the current global configuration object.
  def self.configure
    yield configuration
  end
end
