module Heracles
  module Fielded
    module FieldAttributable
      extend ActiveSupport::Concern

      MODULE_NAME = :FieldAttributes

      included do
        class_attribute :data_attributes
        class_attribute :config_attributes

        self.data_attributes    = []
        self.config_attributes  = []
      end

      module ClassMethods
        # Add an attribute simply stored in the `data` Hash
        def data_attribute(attribute_name)
          # Record the attribute name
          self.data_attributes += [attribute_name.to_sym] unless self.data_attributes.include?(attribute_name.to_sym)

          if const_defined?(MODULE_NAME, _search_ancestors=false)
            mod = const_get(MODULE_NAME)
          else
            mod = const_set(MODULE_NAME, Module.new)
            include mod
          end

          mod.module_eval do
            attr_accessor :"#{attribute_name}_before_fallback"

            # Create some custom accessors
            define_method(:"#{attribute_name}_before_fallback") do
              data[attribute_name.to_s]
            end

            define_method(attribute_name) do
              attribute_before_fallback = send(:"#{attribute_name}_before_fallback")
              attribute_present = attribute_before_fallback.present? || attribute_before_fallback == false

              if !attribute_present
                field_fallback ? field_fallback.send(attribute_name) : attribute_before_fallback
              else
                attribute_before_fallback
              end
            end

            define_method(:"#{attribute_name}=") do |new_value|
              send(:"#{attribute_name}_before_fallback=", new_value).tap do |changed_value|
                will_change!
                data[attribute_name.to_s] = changed_value
              end
            end
          end
        end

        def config_attribute(attribute_name)
          # Record the attribute name
          self.config_attributes += [attribute_name.to_sym] unless self.config_attributes.include?(attribute_name.to_sym)

          if const_defined?(MODULE_NAME, _search_ancestors=false)
            mod = const_get(MODULE_NAME)
          else
            mod = const_set(MODULE_NAME, Module.new)
            include mod
          end

          mod.module_eval do
            define_method(attribute_name) do
              instance_variable_get(:"@#{attribute_name}")
            end

            define_method(:"#{attribute_name}=") do |new_value|
              instance_variable_set(:"@#{attribute_name}", new_value)
            end
          end
        end
      end
    end
  end
end
