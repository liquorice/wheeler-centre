{
  example: "%Y-%m-%d",
  admin_date: "%-d %b %Y"
}.
  each do |name, format|
    Time::DATE_FORMATS[name] = format
    Date::DATE_FORMATS[name] = format
  end
