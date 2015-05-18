class BulkPublicationJob < Que::Job
  def run(bulk_publication_id)
    @action = BulkPublicationAction.find(bulk_publication_id)

    ActiveRecord::Base.transaction do
      # Change published status
      if total_search.size > 0
        total_search.each do |record|
          record.update(published: @action.action == "publish" ? true : false)
        end
      end

      # Mark action as completed
      @action.update(completed_at: Time.now)

      destroy
    end
  end

private

  # Get all available records count (otherwise Sunspot returns only 40 per page)
  memoize \
  def total_records
    Heracles::Site.first.page_classes.map{ |item| item.all.count }.inject(:+)
  end

  # Pass total records count to Sunspot
  memoize \
  def total_search
    sunpot_query({q: @action.tags},  @action.site_id, total_records).results
  end

end
