module Heracles
  class Insertion < ActiveRecord::Base
    include Contracts

    belongs_to :page, class_name: "Heracles::Page", touch: true

    Contract ({page: Page, field: String, inserted: RespondTo[:insertion_key]}) => self
    def self.register(values={})
      find_or_create_by(page: values[:page], field: values[:field], inserted_key: values[:inserted].insertion_key)
    end

    Contract Page => ActiveRecord::Relation
    def self.on_page(page)
      where(page: page)
    end

    Contract RespondTo[:insertion_key] => ActiveRecord::Relation
    def self.for_inserted(inserted)
      where(inserted_key: inserted.insertion_key)
    end

    Contract Any => Or[Any, nil]
    def inserted_record
      return nil if inserted_key.blank?

      # Extract the class and ID from the key (e.g. "heracles/assets/123")
      key_parts   = inserted_key.split("/")
      class_name  = key_parts[0...-1].join("/")
      record_id   = key_parts[-1]

      begin
        class_name.classify.constantize.find(record_id)
      rescue NameError
        nil
      end
    end
  end
end
