module ApplicationHelper
  include Heracles::ContentFieldHelper

  # Common helpers sit under lib/helpers
  include TextFormattingHelper

  ### Heracles helpers

  # Use "content_small" by default when rendering image insertables. This can
  # be overridden by calling `render_content` with a different `version`
  # option, e.g.
  #
  #   render_content(image: {version: :content_large})
  #
  def render_content(content_field, options={})
    defaults = {
      image: {version: :content_large}
    }
    options = defaults.deep_merge(options.deep_symbolize_keys)

    super(content_field, options)
  end

  def url_with_domain(url)
    (ENV["CANONICAL_DOMAIN"] || "#{request.protocol}#{request.host_with_port}") + "/" + url.gsub(/^\//, '')
  end

  ### Application specific helpers

  # Cribbed from Padrino:
  # http://rubydoc.info/github/padrino/padrino-framework/master/Padrino/Helpers/AssetTagHelpers:favicon_tag
  def favicon_tag(source, options={})
    type = File.extname(source).gsub('.','')
    options = options.dup.reverse_merge!(:href => image_path(source), :rel => 'icon', :type => "image/#{type}")
    tag(:link, options)
  end

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
