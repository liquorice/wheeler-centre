json.(page, :id, :page_type, :title, :url, :page_order, :published)

include_fields ||= false
if include_fields
  json.(page, :fields_data)
end
