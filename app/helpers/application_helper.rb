module ApplicationHelper

  def format_date(start_date,end_date,length)
    if !end_date.present?
      display_date = "#{I18n.l(start_date, format: :"#{length}_date")}, #{I18n.l(start_date, format: :time_only)}"
    elsif start_date.beginning_of_day == end_date.beginning_of_day
      display_date = "#{I18n.l(start_date, format: :"#{length}_date")}, #{I18n.l(start_date, format: :time_only)}-#{I18n.l(end_date, format: :time_only)}"
    else
      display_date = "#{I18n.l(start_date, format: :"#{length}_date")}—#{I18n.l(end_date, format: :"#{length}_date")}"
    end
    display_date
  end

end
