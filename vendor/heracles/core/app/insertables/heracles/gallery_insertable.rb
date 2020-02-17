module Heracles
  class GalleryInsertable < Insertable
    def assets
      @assets ||= @page.site.assets.where(id: asset_ids)
    end

    def register_insertions(insertion_attrs={})
      return unless assets

      assets.each do |asset|
        Insertion.register(insertion_attrs.merge(page: @page, inserted: asset))
      end
    end

    private

    def asset_ids
      ids = @data[:assets_data].map { |data| data[:asset_id] } if @data[:assets_data].present?
      Array.wrap(ids)
    end

  end
end
