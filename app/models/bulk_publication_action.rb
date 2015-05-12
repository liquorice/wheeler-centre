class BulkPublicationAction < ActiveRecord::Base
  validates :site_id, :user_id, :tags, :action, presence: true
end
