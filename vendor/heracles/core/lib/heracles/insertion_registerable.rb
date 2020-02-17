module Heracles
  module InsertionRegisterable
    extend ActiveSupport::Concern

    def insertion_key
      "#{self.class.model_name.cache_key}/#{id}"
    end
  end
end
