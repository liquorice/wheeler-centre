module Heracles
  module Fielded
    class AssociatedPagesField < Field
      data_attribute :page_ids
      config_attribute :field_page_type
      config_attribute :field_page_parent_url

      def page_ids
        Array.wrap(super)
      end

      def pages
        find_pages
      end

      def data_present?
        pages.present?
      end

      def assign(attributes={})
        attributes.symbolize_keys!
        self.page_ids = attributes[:page_ids].presence
      end

      def as_json(*)
        super.tap do |json|
          json.merge!(pages: pages_as_json)
        end
      end

      def to_s
        if pages.length > 0
          descriptor = "page#{'s' if pages.length > 1}"
          "#{pages.count} #{descriptor}"
        else
          "None"
        end
      end

      def to_summary
        to_s
      end

      def register_insertions
        pages.each do |associated_page|
          Insertion.register(page: @fields.model, field: field_name, inserted: associated_page)
        end
      end

      private

      def find_pages
        return Heracles::Page.none if page_ids.blank?

        # Respect the order of the pages as specified in IDs list
        Heracles::Page.where(id: page_ids).reorder(pages_order_sql)
      end

      def pages_order_sql
        sql = "CASE pages.id "
        page_ids.each_with_index do |id, position|
          sql += "WHEN '#{id}' THEN #{position} "
        end
        sql += "END"
        sql
      end

      def pages_as_json
        pages.map { |page|
          {
            title: page.title,
            url:   page.url,
            published:  page.published
          }
        }
      end
    end
  end
end
