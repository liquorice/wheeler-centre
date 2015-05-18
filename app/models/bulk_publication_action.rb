class BulkPublicationAction < ActiveRecord::Base
  validates :site_id, :user_id, :tags, :action, presence: true

  scope :in_progress, ->(site_id, user_id) { where("site_id = ? AND user_id = ? AND completed_at IS ?", site_id, user_id, nil).order("id DESC") }

  def readable_tags
    tags.split(",").map{|tag| "<i>#{tag}</i>"}.join(", ").html_safe
  end
end
