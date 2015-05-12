module BulkPublicationSearch

  def sunpot_query(params, site_id, per_page)
    tags = params[:q].split(",")

    Sunspot.search(Heracles::Site.first.page_classes) do
      all_of do
        tags.each{ |tag| with :tags, tag }
      end
      with :site_id, site_id
      order_by :created_at, :desc
      facet :page_type
      paginate page: params[:page] || 1, per_page: per_page
    end
  end

end
