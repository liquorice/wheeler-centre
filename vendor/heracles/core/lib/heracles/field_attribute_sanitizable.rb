module Heracles
  module Fielded
    module FieldAttributeSanitizable
      extend ActiveSupport::Concern

      MODULE_NAME = :SanitizableFieldAttributes

      SANITIZE_CONFIG = {
        tags:
          %w(a abbr address article aside b bdi bdo body blockquote br caption
            col colgroup data del div em figcaption figure footer h1 h2 h3 h4
            h5 h6 header hgroup hr html i img ins li main nav ol p rp rt ruby
            section span style strong summary sup table tbody td tfoot th
            thead title tr ul wbr),
        attributes:
          %w(contenteditable insertable value) +  # insertable `div` attributes
          %w(data-asset-id data-page-id) +        # custom `a` attributes
          %w(abbr align alt axis bgcolor border border cellpadding cellspacing
            cite class colspan datetime dir frame headers height hidden href
            hreflang id lang media name rel reversed rowspan rules scope
            scoped sortable sorted span src start style summary tabindex
            target title translate type valign value width)
      }

      included do |base|
        config_attribute :field_sanitize_html

        if const_defined?(MODULE_NAME, _search_ancestors=false)
          mod = const_get(MODULE_NAME)
        else
          mod = const_set(MODULE_NAME, Module.new)
          include mod
        end

        mod.module_eval do
          # Define this in a place where it is called before the accessor
          # method provided by `FieldAttributable`.
          def field_sanitize_html
            return @field_sanitize_html if defined?(@field_sanitize_html)
            @field_sanitize_html = true
          end
        end
      end

      module ClassMethods
        def data_attribute(attribute_name)
          # Define the standard accessors
          super

          if const_defined?(MODULE_NAME, _search_ancestors=false)
            mod = const_get(MODULE_NAME)
          else
            mod = const_set(MODULE_NAME, Module.new)
            include mod
          end

          mod.module_eval do
            define_method(attribute_name) do
              value = super()
              value.kind_of?(String) ? value.html_safe : value
            end

            define_method(:"#{attribute_name}=") do |new_value|
              return super(new_value) if !new_value.kind_of?(String) || !field_sanitize_html

              # If the new_value has been frozen, unfreeze it before sanitising.
              new_value = new_value.dup if new_value.to_s.frozen?

              super(ActionController::Base.helpers.sanitize(new_value.to_s, SANITIZE_CONFIG))
            end
          end
        end
      end
    end
  end
end
