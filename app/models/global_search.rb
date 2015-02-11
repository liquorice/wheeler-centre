class GlobalSearch
  def initialize(&block)
    @search = Sunspot.search(Heracles::Site.first.page_classes, &block)
  end

  def results
    @search.results
  end

  def facet
    @search.facet(:page_type)
  end
end
