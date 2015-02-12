module SearchesHelper
  def humanize_page_type_facet(type)
    case type
    when "itunes_category"
     "iTunes categories"
    when "vpla_book"
     "Victorian Premier's Literary Awards books"
    when "content_page"
     "Pages"
    when "vpla_category"
     "Victorian Premier's Literary Awards categories"
    else
      type.humanize.pluralize
    end
  end

  def humanize_page_type(type)
    case type
    when "vpla_book"
      "Victorian Premier's Literary Awards book"
    when "content_page"
      "Page"
    else
      type.humanize
    end
  end
end