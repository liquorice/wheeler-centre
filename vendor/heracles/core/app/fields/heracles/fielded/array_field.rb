module Heracles
  module Fielded
    class ArrayField < Field
      data_attribute :values

      # For supplying options to the "checkbox" editor_type
      config_attribute :field_option_values

      def values
        Array.wrap(super)
      end

      def data_present?
        values.present?
      end

      def assign(attributes={})
        attributes.symbolize_keys!
        self.values = Array.wrap(attributes[:values]).presence
      end

      def to_s
        values.to_s
      end

      def to_summary
        values.join(", ")
      end
    end
  end
end
