class BulkPublicationSearch
  attr_reader :params, :site_id, :tags

  def initialize(options = {})
    @params  = options.fetch(:params)
    @site_id = options.fetch(:site_id)
    @tags    = @params[:q].split(",")
  end

  def results
    Heracles::Page.tagged_with(@tags)
  end

  private

  def page_classes
    Heracles::Site.find(@site_id).page_classes
  end

end
