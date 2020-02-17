module Heracles
  module Fielded
    class AssetsField < Field
      data_attribute :asset_ids
      config_attribute :field_assets_file_type

      def asset_ids
        Array.wrap(super)
      end

      def assets
        find_assets
      end

      def data_present?
        assets.present?
      end

      def assign(attributes={})
        attributes.symbolize_keys!
        self.asset_ids = attributes[:asset_ids].presence
      end

      def as_json(*)
        super.symbolize_keys.tap do |json|
          # delete `nil` values for asset_ids, which breaks the editor form
          json.delete(:asset_ids) if json[:asset_ids].nil?
          json.merge!(assets: assets_as_json)
        end
      end

      def to_s
        if assets.length > 0
          descriptor = "asset#{'s' if assets.length > 1}"
          "#{assets.count} #{descriptor}"
        else
          "None"
        end
      end

      def to_summary
        to_s
      end

      private

      def assets_order_sql
        sql = "CASE assets.id "
        asset_ids.each_with_index do |id, position|
          sql += "WHEN '#{id}' THEN #{position} "
        end
        sql += "END"
        sql
      end

      def find_assets
        return Heracles::Asset.none if asset_ids.blank?

        # Respect the order of the assets as specified in IDs list
        Heracles::Asset.where(id: asset_ids).reorder(assets_order_sql)
      end

      def assets_as_json
        assets.map { |asset|
          {
            asset_id: asset.id,
            asset_field_name: asset.try(:file_name)
          }
        }
      end
    end
  end
end
