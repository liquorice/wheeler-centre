class BulkPublicationJob < Que::Job
  def run(bulk_publication_id)
    @action = BulkPublicationAction.find(bulk_publication_id)

    ActiveRecord::Base.transaction do
      # Change published status
      if results.size > 0
        results.each do |record|
          record.update(published: @action.action == "publish" ? true : false)
        end
      end

      # Mark action as completed
      @action.update(completed_at: Time.now)

      destroy
    end
  end

private

  memoize \
  def results
    BulkPublicationSearch.new(tags: @action.tags, site_id: @action.site_id).results
  end

end
