class BulkPublicationSearch
  attr_reader :params, :site_id, :tags

  def initialize(options = {})
    @tags    = options.fetch(:tags).split(",")
    @site_id = options.fetch(:site_id)
  end

  def results
    Heracles::Page.tagged_with(@tags).order("created_at DESC")
  end

  private

  def page_classes
    Heracles::Site.find(@site_id).page_classes
  end

end
