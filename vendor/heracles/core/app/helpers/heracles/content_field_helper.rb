module Heracles
  module ContentFieldHelper
    class SiteNotFound < StandardError; end

    def render_content(content_field, options={})
      options = site.configuration.render_content_defaults.deep_merge(options)

      render_content_with_filters(content_field, standard_content_filters, options)
    end

    def render_content_with_filters(content_field, filters, options)
      raise SiteNotFound unless try(:site)

      options  = {controller: controller, site: site}.merge(options)
      pipeline = ContentFieldRendering::Pipeline.new(filters)
      pipeline.call(content_field, options)
    end

    private

    def standard_content_filters
      [
        ContentFieldRendering::InsertablesFilter,
        ContentFieldRendering::AssetsFilter,
        ContentFieldRendering::PageLinkFilter
      ]
    end
  end
end
