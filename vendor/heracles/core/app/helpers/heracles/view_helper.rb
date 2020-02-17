module Heracles
  module ViewHelper
    class SiteNotFound < StandardError; end

    def next_sibling(page, wrap_around = false)
      siblings = page.siblings.in_order
      if siblings.any?
        index = siblings.find_index {|p| p.id == page.id}
        if index >= siblings.length - 1
          siblings.first if wrap_around
        else
          siblings[index + 1]
        end
      end
    end

    def prev_sibling(page, wrap_around = false)
      siblings = page.siblings.in_order
      if siblings.any?
        index = siblings.find_index {|p| p.id == page.id}
        if index <= 0
          siblings.last if wrap_around
        else
          siblings[index - 1]
        end
      end
    end

    def excerptify_html(html, length = 350, allowed_tags = "p em strong br a")
      strip_empty_block_html(
        truncate_html(sanitize(html, tags: allowed_tags.split(' ')), length: length)
      )
    end

    def field_has_content(field)
      field = if field.is_a? String
        page.fields[field]
      else
        field
      end
      field && field.data_present?
    end
  end
end
