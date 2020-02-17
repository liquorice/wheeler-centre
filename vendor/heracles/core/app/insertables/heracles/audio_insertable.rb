module Heracles
  class AudioInsertable < Insertable
    def asset
      @asset ||= @page.site.assets.find_by_id(@data[:asset_id])
    end

    def register_insertions(insertion_attrs={})
      return unless asset

      Insertion.register(insertion_attrs.merge(page: @page, inserted: asset))
    end
  end
end
