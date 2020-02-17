module Heracles
  module Fielded
    # Field base class
    #
    # `Field` has `data` which is a Hash for storing the actual JSON
    # data of a field. A field attached to a `Fields` instance in
    # `fields` just proxies the hash from the model, but a new field
    # can still be created unattached and stores the data in `@data`
    # temporarily. It can then be attached to a `Fields` with
    # `fields[field_name] = field`.
    #
    # Each `Field` has a `type` which is the unqualified class name
    # (no namespace) without the `Field` suffix. For example, the
    # type "text" corresponds to the field class `Fielded::TextField`.
    # The names of field classes are also ordered by namespace nesting,
    # meaning an application can specialise a field type by overriding
    # a field class a the top level. For example, `Fielded::TextField`
    # be overridden with a class in the application called `TextField`.
    #
    class Field
      include ActiveModel::Validations

      include FieldAttributable
      include FieldAttributeSanitizable

      TYPE_FROM_CLASS_NAME = /\A(?:.*::)?(.*?)Field\Z/

      validate :validate_required_field

      ### Factories

      def self.new_with_type_and_namespace(type, namespace, *args)
        field_class_for_type_and_namespace(type, namespace).new(*args)
      end

      # Create a new proxy to an existing field in the given `Fields` instance `fields` named `name`.
      def self.new_from_fields(fields, field_name)
        field_name = field_name.to_s
        field_type = fields.data[field_name]["field_type"]
        raise "Missing field type" unless field_type.present?

        field_class_for_type_and_namespace(field_type, fields.namespace).allocate.tap do |instance|
          instance.initialize_from_fields(fields, field_name)
        end
      end

      def self.field_class_for_type_and_namespace(type, namespace)
        site_fields   = namespace.constants.grep(/\w+Field$/)         { |class_name| class_name.to_s.underscore }
        global_fields = Heracles::Fielded.constants.grep(/\w+Field$/) { |class_name| class_name.to_s.underscore }

        field_type_name   = "#{type}_field"
        field_class_name  = "#{type.to_s.camelize}Field"

        if site_fields.detect { |field| field == field_type_name }
          namespace.const_get(field_class_name)
        elsif global_fields.detect { |field| field == field_type_name }
          Heracles::Fielded.const_get(field_class_name)
        else
          Heracles::Fielded::UnsupportedField
        end
      end

      ### Initializers

      # Only used by `Fields` to create a new proxy
      def initialize_from_fields(fields, field_name)
        field_name = field_name.to_s

        # Assign the private vars
        @fields = fields
        @field_name = field_name

        # Then initialize normally
        initialize
      end

      # An initial value can be supplied to initialize
      def initialize(*args)
        raise "Cannot instantiate base field type" if self.class == Field

        data["field_type"] = field_type
        assign(*args) if args.length > 0
      end

      ### Accessors

      # Field types are the unqualified, underscored class name without the
      # "Field" suffix and are mainly used for reinstantiation.
      def self.field_type
        name[/([^:]+)Field\Z/, 1].underscore
      end

      delegate :field_type, to: :class

      config_attribute :field_label
      config_attribute :field_required
      config_attribute :field_hint
      config_attribute :field_editor_type
      config_attribute :field_editor_columns
      config_attribute :field_editor_input_size

      # A string expression to add conditional display logic to the field. On
      # the admin page editors, the field will only display if the expression
      # evaluates to true.
      #
      # Uses the [Filtrex](https://github.com/joewalnes/filtrex) expression
      # language. The variables available to use in the expression are the
      # other fields on the page, accessible by their field names.
      #
      # Example:
      #
      #   "hero_image_type.value == 'extra_large'"
      #
      # This expression will only show the field if the "hero_image_type"
      # field has a value attribute of "extra_large".
      config_attribute :field_display_if

      config_attribute :field_defaults # n.b. see custom setter below.
      config_attribute :field_fallback

      def field_label
        @field_label.presence || field_name.to_s.humanize
      end

      def field_editor_type
        @field_editor_type.present? ? "#{field_type}__#{@field_editor_type}" : field_type
      end

      attr_reader :field_name

      def field_name=(new_name)
        new_name = new_name.to_s

        # Move the data store if we are attached to fields
        if fields
          fields.will_change!
          fields.data[new_name] = fields.data.delete(field_name)
        end

        @field_name = new_name
      end

      def field_defaults=(defaults)
        defaults.each do |key, val|
          if respond_to?(:"#{key}=")
            # Only set the default if there's nothing stored in the data yet.
            # Bypass the getter methods to make sure defaults apply reliably.
            send(:"#{key}=", val) if data[key.to_s].nil?
          end
        end
      end

      # Store this field's data as a JSON-serializable object.
      #
      # Be careful that every mutation should call `will_change!` to mark the
      # underlying model's attribute dirty.
      def data
        if fields
          fields.data[field_name]
        else
          @data ||= {}
        end
      end

      # Fields proxy
      attr_reader :fields

      def fields=(new_fields)
        # We need a name to have fields
        unless field_name
          raise "need a name first; use fields[name] = fields"
        end

        # Detach from existing fields
        if new_fields.nil? && @fields
          # Detach the data into temporary store
          @data = @fields.data[field_name]
          # Tell fields we're gone
          @fields.delete(field_name)
          # Forget fields
          @fields = nil

        # Attach to new fields
        elsif new_fields
          # Detach first if previous fields
          self.fields = nil if fields
          # Transfer and forget the temporary data store
          new_fields.will_change!
          new_fields.data[field_name] = @data
          @data = nil
          # Retain the new fields
          @fields = new_fields
        end
      end

      def field_id_path
        return "" unless fields
        [fields.id_path, field_name].join("#")
      end

      def field_url_path
        return "" unless fields
        [fields.url_path, field_name].join("#")
      end

      ### Predicates

      # For the "required" validation
      def data_present?
        raise NotImplemented
      end

      def stale?
        !fields.has_config?(field_name)
      end

      def supported?
        true
      end

      ### Commands

      # Shortcut to mark fields as dirty, if we're attached.
      def will_change!
        fields.try(:will_change!)
      end

      # Sets the value of this field, i.e. from the initializer.
      # Each field type should override and do something sensible.
      def assign(*)
        raise NotImplemented
      end

      def register_insertions
        # No-op by default.
      end

      ### Convertors

      # TODO: documentation
      # TODO: rename `as_data_json`
      def as_json(*)
        # Create a hash of the field config
        config = {}
        self.class.config_attributes.each do |attr|
          config[attr] = send(attr) if send(attr).present?
        end
        config[:field_id_path]  = field_id_path
        config[:field_url_path] = field_url_path
        config[:field_stale] = stale?
        config[:field_supported] = supported?

        # Add to the field's own stored data
        data.merge(field_name: field_name, field_config: config, errors: errors)
      end

      private

      ### Private validation methods

      def validate_required_field
        if field_required
          errors.add(:base, "is required") unless data_present?
        end
      end
    end
  end
end
