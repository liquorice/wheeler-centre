module Heracles
  module Fielded
    class BooleanField < Field
      config_attribute :field_question_text
      data_attribute :value

      def field_question_text
        @field_question_text.presence || "#{field_label}?"
      end

      def data_present?
        !value.nil?
      end

      def assign(attributes={})
        attributes.symbolize_keys!
        self.value = !["", "0", "no", "false"].include?(attributes[:value].to_s)
      end

      def to_s
        value.to_s
      end

      def to_summary
        value ? "Yes" : "No"
      end
    end
  end
end
