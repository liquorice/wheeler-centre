module Heracles
  class Insertable

    def initialize(page, attributes={})
      @page = page
      @node_attributes = attributes.with_indifferent_access
      @data = JSON.parse(@node_attributes[:value]).with_indifferent_access
    end

    def register_insertions(insertion_attrs={})
      # No-op by default.
    end
  end
end
