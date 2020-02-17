module Heracles
  module Fielded
    # Fields is the main proxy which manages `Field` instances.
    class Fields
      include ActiveModel::Validations

      ### Validations

      validate :validate_each_field

      ### Initializer

      def initialize(model, attribute)
        # Where this proxy is attached
        @model = model
        @attribute = attribute

        # Cache field proxy instances
        @fields = {}
      end

      ### Accessors

      attr_reader :model
      delegate :persisted?, to: :model

      def namespace
        model.try(:namespace) || self.class.parent
      end

      def data
        model.public_send(@attribute) or model.public_send("#{@attribute}=", {})
      end

      def data=(value)
        model.public_send("#{@attribute}=", value)
      end

      def id_path
        model.id.to_s
      end

      def url_path
        "/#{model.url}"
      end

      def [](field_name)
        field_name = field_name.to_s

        @fields[field_name] ||= if data[field_name]
          Field.new_from_fields(self, field_name)
        end
      end

      def []=(field_name, value)
        field_name = field_name.to_s

        will_change!

        if value.is_a? Field
          value.field_name = field_name
          value.fields = self
          @fields[field_name] = value
        else
          self[field_name].assign(value)
        end
      end

      ### Predicates

      def empty?
        data.empty?
      end
      alias_method :blank?, :empty?

      def has_config?(field_name)
        model.field_names.map(&:to_sym).include?(field_name.to_sym)
      end

      ### Commands

      # All mutations should call `will_change!` before changes to correctly
      # maintain dirty status on the parent model.
      def will_change!
        model.public_send("#{@attribute}_will_change!")
      end

      def delete(names)
        will_change!
        Array(names).each  do |name|
          data.delete(name)
          @fields.delete(name)
        end
        # TODO: This should probably return the detached Field
      end

      def delete_all_without_config
        remove_fields = all_field_names - model.field_names
        delete(remove_fields) if remove_fields.present?
        remove_fields
      end

      def each
        data.keys.each do |name|
          yield name, self[name]
        end
      end

      def to_a
        all_field_names.map { |name| self[name] }.reject(&:nil?)
      end

      def of_type(field_type)
        to_a.select { |field| field.field_type == field_type }
      end

      private

      ### Private helpers

      def all_field_names
        model.field_names.map(&:to_s) | data.keys.map(&:to_s)
      end

      ### Private validation methods

      def validate_each_field
        each do |name, field|
          field.valid? or field.errors.each do |attribute, error|
            error_attribute = (attribute == :base ? name : "#{name}.#{attribute}")
            errors.add(error_attribute, error)
          end
        end
      end
    end
  end
end
