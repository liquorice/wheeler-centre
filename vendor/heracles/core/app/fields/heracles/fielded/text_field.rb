module Heracles
  module Fielded
    # Just a simple text field
    class TextField < Field
      data_attribute :value

      # For supplying options to the "radio" or "select" editor_types
      config_attribute :field_option_values

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

      def to_summary
        value.present? ? to_s.truncate(100) : ""
      end
    end
  end
end
