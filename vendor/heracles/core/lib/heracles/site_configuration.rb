module Heracles
  class SiteConfiguration
    attr_reader :site

    def initialize(site)
      @site = site
    end

    def method_missing(method_name, *args)
      editable_configuration.try(method_name, *args) || static_configuration.try(method_name, *args)
    end

    private

    def static_configuration
      site.module.configuration
    end

    memoize \
    def editable_configuration
      site.pages.find_by_url(static_configuration.configuration_page_url)
    end
  end
end
