module Heracles
  module Sites
    module WheelerCentre
      class ExternalVideoField < Heracles::Fielded::Field

        data_attribute :value
        data_attribute :youtube

        def data_present?
          value.present?
        end

        def assign(attributes={})
          attributes.symbolize_keys!
          self.value   = attributes[:value].presence
          self.youtube = attributes[:youtube].presence
        end

        def to_s
          value.to_s
        end

        def to_summary
          value.present? ? to_s.truncate(100) : ""
        end

      end
    end
  end
end
