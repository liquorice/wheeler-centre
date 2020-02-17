module Heracles
  module ContentFieldRendering
    class Pipeline
      attr_reader :filters

      def initialize(filters)
        @filters = filters.flatten.freeze
      end

      def call(content_field, options={})
        return '' unless content_field
        options = options.deep_symbolize_keys.freeze
        html_doc = Nokogiri::HTML::fragment(content_field.value)
        html_doc = filters.inject(html_doc) { |doc, filter| filter.new(doc, options).call }
        html_doc.to_s.html_safe
      end
    end
  end
end
