module Heracles
  module ContentFieldRendering
    class Filter
      attr_reader :options

      attr_reader :html_doc
      attr_reader :controller
      attr_reader :site

      def initialize(html_doc, options = nil)
        @html_doc   = html_doc
        @options    = (options || {})
        @site       = options[:site]
        @controller = options[:controller]
      end

      def call
        html_doc
      end
    end
  end
end
