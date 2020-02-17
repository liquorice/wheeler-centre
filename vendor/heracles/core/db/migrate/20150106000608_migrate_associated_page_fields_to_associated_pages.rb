class MigrateAssociatedPageFieldsToAssociatedPages < ActiveRecord::Migration
  def up
    # Convert old, singular, associated_page fields, e.g.
    #
    #   {"field_type" => "associated_page", "page_id" => "123"}
    #
    # to the modern, multi-page field, e.g.
    #
    #   {"field_type" => "associated_pages", "page_ids" => ["123"]}
    #
    Heracles::Page.find_each do |page|
      migrated_fields_data = page.fields_data.each_with_object({}) { |(field_name, field_data), memo_hash|
        migrated_data = field_data.dup
        if migrated_data["field_type"] == "associated_page"
          migrated_data["field_type"] = "associated_pages"
          migrated_data["page_ids"] = [migrated_data.delete("page_id")]
        end

        memo_hash[field_name] = migrated_data
      }

      page.update_column(:fields_data, migrated_fields_data) if migrated_fields_data != page.fields_data
    end
  end

  def down
    # No downwards operation. This is intended to be a once-off migration for sites with old data.
  end
end
