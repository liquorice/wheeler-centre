module Heracles
  class Collection < Heracles::Page
    ### Associations

    def pages
      @pages ||= siblings.where(collection_id: id).order(pages_order_by)
    end

    ### Callbacks

    after_save :mark_as_hidden

    ### Validations

    validate :validate_sort_attribute
    validate :validate_sort_direction

    ### Page config

    def fields_config
      super + [
        {
          name:           "contained_page_type",
          type:           :text,
          label:          "Contained page type",
          required:       true,
          editor_type:    :select,
          option_values:  Array.wrap(site.try(:page_classes)).reject(&:collection?).map(&:page_type)
        },
        {
          name:           "sort_attribute",
          type:           :text,
          label:          "Sort attribute",
          required:       true,
          editor_type:    :select,
          option_values:  %w(created_at title),
          editor_columns: 6
        },
        {
          name:           "sort_direction",
          type:           :text,
          label:          "Sort direction",
          required:       true,
          editor_type:    :select,
          option_values:  %w(ASC DESC),
          editor_columns: 6
        }
      ]
    end

    ### Accessors

    def contained_page_type
      fields["contained_page_type"].try(:value)
    end

    def pages_order_by
      "#{sanitized_sort_attribute} #{sanitized_sort_direction}"
    end

    ### Predicates

    def self.page?
      false
    end

    def self.collection?
      true
    end

    def child_pages_allowed?
      false
    end

    private

    ### Private helpers

    def sanitized_sort_attribute
      if %w(title created_at).include?(fields["sort_attribute"].try(:value))
        fields["sort_attribute"].value
      else
        "created_at"
      end
    end

    def sanitized_sort_direction
      if %w(ASC DESC).include?(fields["sort_direction"].try(:value).to_s.upcase)
        fields["sort_direction"].value
      else
        "DESC"
      end
    end

    ### Callback methods

    def mark_as_hidden
      self.published = false
      self.hidden = true
    end

    ### Private validation methods

    def validate_sort_attribute
      if sanitized_sort_attribute != fields["sort_attribute"].try(:value)
        errors.add :sort_attribute, "is not a valid attribute for sorting"
      end
    end

    def validate_sort_direction
      if sanitized_sort_direction != fields["sort_direction"].try(:value).to_s.upcase
        errors.add :sort_direction, "must be ASC or DESC"
      end
    end
  end
end
