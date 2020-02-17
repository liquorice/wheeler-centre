module Heracles
  class UpdatePage
    include Interactor

    def call
      unless context.page.update_attributes(context.page_params)
        context.fail!
      end

      purge_cdn_cache
    end

    private

    def purge_cdn_cache
      site = context.page.site

      if site.has_edge_delivery?
        client = Varnisher::Purger.new('PURGE', context.page.absolute_url, site.primary_edge_hostname)
        client.send
      end
    end
  end
end
