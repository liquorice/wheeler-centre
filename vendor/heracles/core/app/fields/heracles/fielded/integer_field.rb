module Heracles
  module Fielded
    class IntegerField < Field
      data_attribute :value

      def data_present?
        value.present?
      end

      def assign(attributes={})
        attributes.symbolize_keys!
        self.value = attributes[:value].presence and attributes[:value].to_i
      end

      def to_s
        value.to_s
      end
      alias_method :to_summary, :to_s
    end
  end
end
