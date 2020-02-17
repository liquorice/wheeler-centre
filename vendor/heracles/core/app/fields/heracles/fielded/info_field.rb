module Heracles
  module Fielded
    class InfoField < Field
      data_attribute :value

      config_attribute :field_show_header
      config_attribute :field_text

      def data_present?
        value.present?
      end

      def assign(attributes={})
        attributes.symbolize_keys!
        self.value = attributes[:value].presence
      end

      def to_s
        value.to_s
      end
      alias_method :to_summary, :to_s
    end
  end
end
