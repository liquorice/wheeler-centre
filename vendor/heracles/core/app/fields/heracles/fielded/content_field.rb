module Heracles
  module Fielded
    # Rich content (HTML with insertables)
    class ContentField < Field
      data_attribute :value

      config_attribute :field_disable_insertables
      config_attribute :field_with_insertables
      config_attribute :field_without_insertables

      config_attribute :field_disable_buttons
      config_attribute :field_with_buttons
      config_attribute :field_without_buttons

      def data_present?
        value.present?
      end

      def assign(attributes={})
        attributes.symbolize_keys!
        self.value = attributes[:value].presence
      end

      def insertables
        html_doc = Nokogiri::HTML::fragment(value)
        html_doc.css("[insertable][value]").map do |insertable_node|
          insertable_type   = insertable_node["insertable"]
          insertable_class  = find_insertable_class(insertable_type)

          insertable_class.new(@fields.model, insertable_node.attributes)
        end
      end

      def to_s
        value.to_s
      end

      def to_summary
        HTML::FullSanitizer.new.sanitize(value.to_s).gsub("\n", " ").truncate(100)
      end

      def register_insertions
        insertables.each do |insertable|
          insertable.send(:register_insertions, field: field_name) if insertable.respond_to?(:register_insertions)
        end
      end

      private

      ### Private helpers

      def find_insertable_class(insertable_type)
        class_name = insertable_type.camelize + "Insertable"
        site_class = "#{@fields.namespace}::#{class_name}".constantize  rescue nil
        base_class = "Heracles::#{class_name}".constantize              rescue nil

        site_class || base_class || Heracles::Insertable
      end
    end
  end
end
