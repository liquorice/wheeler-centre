module Heracles
  module Fielded
    # A Field to represent field types that are no longer supported (eg: a  field type that is renamed but still used in a page config)
    class UnsupportedField < Field
      def initialize(*)
        raise "Cannot initialize an UnsupportedField without existing data" if field_type.blank?

        super
      end

      def field_type
        # Return the existing field type (which is no longer supported)
        data["field_type"]
      end

      def data_present?
        data.present?
      end

      def assign(attributes={})
        will_change!

        # Assign anything we're given straight through to the data, since we want to preserve it
        attributes.each do |key, value|
          data[key] = value
        end
      end

      def to_s
        "UnsupportedField: #{data.keys.join(', ')}"
      end

      def to_summary
        "UnsupportedField: #{data.keys.join(', ')}"
      end

      def supported?
        false
      end
    end
  end
end
