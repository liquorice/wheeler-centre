module Heracles
  module Fielded
    class DateTimeField < Field
      data_attribute :value
      data_attribute :time_zone
      config_attribute :field_is_date_only

      attr_accessor :value_date, :value_time

      validates :value_date,  presence: true, if: :any_value_component_present?
      validates :value_time,  presence: true, if: "any_value_component_present? && !field_is_date_only"
      validates :time_zone,   presence: true, if: "any_value_component_present? && !field_is_date_only"

      alias_method :value_in_data, :value
      def value
        value = value_from_components || value_in_data
        value.kind_of?(String) ? Time.zone.parse(value) : value
      end

      alias_method :value_in_data=, :value=
      def value=(new_value)
        new_value = Time.parse(new_value) if new_value.kind_of?(String)

        self.value_in_data  = new_value.try(:utc).try(:to_s)
        self.time_zone = new_value.try(:time_zone).try(:name) || new_value.try(:zone)
      end

      def value_in_time_zone
        if time_zone.present?
          value.try(:in_time_zone, time_zone)
        else
          value.try(:in_time_zone) # fall back to the current time zone
        end
      end

      def value_date
        if @value_date
          date = @value_date.respond_to?(:year) ? @value_date : (Time.parse(@value_date) rescue nil)
          @value_date = date.try(:strftime, "%F")
        else
          value_in_time_zone.try(:strftime, "%F")
        end
      end

      def value_time
        @value_time || value_in_time_zone.try(:strftime, "%H:%M")
      end

      def data_present?
        value.present? && time_zone.present?
      end

      def assign(attributes={})
        attributes.symbolize_keys!

        self.value_date = attributes[:value_date].presence  if attributes.key?(:value_date)
        self.value_time = attributes[:value_time].presence  if attributes.key?(:value_time)
        self.time_zone  = attributes[:time_zone].presence   if attributes.key?(:time_zone)

        if value_from_components
          self.value = value_from_components
        elsif attributes.key?(:value)
          self.value = attributes[:value]
        end
      end

      def to_s
        value.present? ? value.to_s(:admin_date) : ""
      end
      alias_method :to_summary, :to_s

      def as_json(*)
        super.merge(value_date: value_date, value_time: value_time, time_zone: time_zone, available_time_zones: all_time_zones)
      end

      private

      def all_time_zones
        Hash[*ActiveSupport::TimeZone.all.map { |tz| [tz.name, tz.to_s] }.flatten]
      end

      def all_value_components_present?
        value_components.all?(&:present?)
      end

      def any_value_component_present?
        value_components.any?(&:present?)
      end

      def value_components
        components = [@value_date]
        components += [@value_time, time_zone] unless field_is_date_only
        components
      end

      def value_from_components
        return unless all_value_components_present?

        if field_is_date_only
          date = Time.parse(value_date)
          Time.utc(date.year, date.month, date.day)
        else
          date = Time.parse(@value_date)
          time = Time.parse(@value_time)
          Time.find_zone!(time_zone).local(date.year, date.month, date.day, time.hour, time.min)
        end
      end
    end
  end
end
