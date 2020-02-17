class ResavePagesWithNewSanitizer < ActiveRecord::Migration
  def up
    puts "Re-saving all pages with new content field sanitizer"
    Heracles::Page.find_each do |page|
      page.fields.to_a.each do |field|
        if field.field_type == "content"
          page.fields[field.field_name].value = field.value
        end
      end

      page.save!
    end
  end

  def down
    # no operation required
  end
end
