# Fielded models have a `fields_data` JSON attribute which is proxied by a
# `fields` attribute, a `Fields`, which acts like an array of `Field`
# instances.
#
# Quite similar to ActiveRecord::Store
module Heracles
  module Fielded
    extend ActiveSupport::Concern

    include ClassConfigurable

    included do
      validate :validate_fields
    end

    module ClassMethods
      ### Class-level field config

      def fields_config
        Array.wrap(config[:fields])
      end

      def field_names
        fields_config.map { |field| field[:name] }
      end
    end

    ### Instance-level field config

    def fields_config
      self.class.fields_config
    end

    def field_names
      fields_config.map { |field| field[:name] }
    end

    ### Accessors

    def namespace
      self.class.parent
    end

    def fields_data=(value)
      @fields = nil
      super(value)
    end

    def fields
      @fields ||= Fields.new(self, :fields_data).tap do |fields|
        build_configured_fields(fields)
      end
    end

    # Field editor forms are better made when the fields come as an array.
    def form_fields_json
      fields.to_a.to_json
    end

    def form_fields_json=(json)
      fields_attributes = JSON.parse(json).index_by { |hash| hash["field_name"] }
      fields_attributes.each do |name, data|
        # Delete the field if the destroy flag has been set
        if (data["_destroy"])
          fields.delete(name)
        else
          if (field = fields[name])
            field.assign(data)
          end
        end
      end
    end

    def field?(name)
      !fields[name].nil?
    end

    protected

    ### Private helper methods

    def build_configured_fields(fields)
      fields_config.each do |field_config|
        field_name = field_config[:name]
        if (existing_field = fields[field_name])
          # The field already exists from the model's data. Apply the config to it.
          apply_config_to_field field_config, existing_field
        else
          # This is configured field that doesn't exist in the data yet. Create it.
          new_field = Field.new_with_type_and_namespace(field_config[:type], namespace)
          apply_config_to_field field_config, new_field

          # Then save it to the data.
          fields[field_name] = new_field
        end
      end
    end

    def apply_config_to_field(config, field)
      config_keys = field.class.config_attributes.map { |attr| attr.to_s.sub(/^field_/, "").to_sym }
      config_keys.each do |key|
        if config.key?(key)
          config_value = config[key]
          config_value = instance_eval(&config_value) if config_value.respond_to?(:call)

          field.send(:"field_#{key}=", config_value)
        end
      end
    end

    ### Private validation methods

    def validate_fields
      fields.valid? or fields.errors.each { |attribute, error| errors.add("fields.#{attribute}", error) }
    end
  end
end
