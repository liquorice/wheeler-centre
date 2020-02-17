module Heracles
  class ProcessedAsset < ActiveRecord::Base
    self.table_name = "heracles_processed_assets"

    belongs_to :asset

    scope :processed, -> { where("processed_at IS NOT NULL") }
    scope :unprocessed, -> { where("processed_at IS NULL") }
    scope :by_processor, -> (processor_name) { where(processor: processor_name) }

    def processed?
      processed_at?
    end

    def versions
      data["versions"]
    end
  end
end
