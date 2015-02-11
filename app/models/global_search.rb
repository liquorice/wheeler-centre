class GlobalSearch
  def initialize(&block)
    @search = Sunspot.search(Heracles::Site.first.page_classes, &block)
  end

  def results
    @search.results
  end

  def event_results
    @event_results ||= results.select { |result| result.kind_of?(Heracles::Page) && result.page_type == "event" }
  end
end
