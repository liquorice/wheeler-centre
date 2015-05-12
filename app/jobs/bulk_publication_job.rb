class BulkPublicationJob < Que::Job

  def run(bulk_publication_id)
    bulk_publication_action = BulkPublicationAction.find(bulk_publication_id)
    ActiveRecord::Base.transaction do
      destroy
    end
  end

end
