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
  def render_content(content_field, options={}, filters = nil)
    defaults = {
      image: {version: :content_large}
    }
    options = defaults.deep_merge(options.deep_symbolize_keys)

    filters ||= standard_content_filters
    render_content_with_filters(content_field, filters, options)
  end

  def render_content_in_sections(content_field, options={})
    filters = standard_content_filters + [Heracles::Sites::WheelerCentre::SectionFilter]
    render_content content_field, options, filters
  end

  def url_with_domain(url)
    (ENV["CANONICAL_DOMAIN"] || "#{request.protocol}#{request.host_with_port}") + "/" + url.gsub(/^\//, '')
  end

  def human_boolean(bool)
    bool ? "yes" : "no"
  end

  def duration_to_hms(duration, options={})
    trim_hours = options[:trim_hours] || false
    format = trim_hours ? "%M:%S" : "%H:%M:%S"
    Time.at(duration).gmtime.strftime(format)
  end

  ### Application specific helpers

  def excerptify(text, chars = 220)
    text = strip_tags(text)
    truncate(text, length: chars)
  end

  def force_excerptify_html(html, length = 350, allowed_tags = "p i em strong br")
    truncate_html(
      strip_html(html, allowed_tags),
    length: length)
  end

  def strip_html(html, allowed_tags = "p i em strong br")
    Sanitize.fragment(html, Sanitize::Config.merge(Sanitize::Config::RESTRICTED,
        :elements => Sanitize::Config::RESTRICTED[:elements] + allowed_tags.split(" "),
    ))
  end

  # Cribbed from Padrino:
  # http://rubydoc.info/github/padrino/padrino-framework/master/Padrino/Helpers/AssetTagHelpers:favicon_tag
  def favicon_tag(source, options={})
    type = File.extname(source).gsub('.','')
    options = options.dup.reverse_merge!(:href => image_path(source), :rel => 'icon', :type => "image/#{type}")
    tag(:link, options)
  end

  def format_date(start_date,end_date,options={})
    format = options[:format].to_sym
    date_only = false || options[:date_only]
    if !end_date.present?
      display_date = I18n.l(start_date, format: format)
      unless date_only
        display_date += ", #{I18n.l(start_date, format: :time_only)}"
      end
    elsif start_date.beginning_of_day == end_date.beginning_of_day
      display_date = I18n.l(start_date, format: format)
      unless date_only
        ", #{I18n.l(start_date, format: :time_only)}-#{I18n.l(end_date, format: :time_only)}"
      end
    else
      display_date = "#{I18n.l(start_date, format: format)}—#{I18n.l(end_date, format: format)}"
    end
    display_date
  end

  def indefinite_article_for_number(number)
    vowels = %w( a e i o u )
    (vowels.include? number.humanize[0]) ? "an" : "a"
  end

  ###
  # TOPICS
  ###

  # Set of primary tags/categories that content falls under
  def topics_page
    site.pages.find_by_url("topics")
  end

  def primary_topics
    topics_page.children.in_order.visible.published.of_type("topic")
  end

  # Return an array of all the primary topics for a given `page`
  def select_primary_topics_for_page(page)
    matches = []
    if page.fields[:topics].data_present?
      page.fields[:topics].pages.each do |topic|
        match = primary_topic_for_topic(topic)
        matches << match if match
      end
    end
    matches.uniq
  end

  def primary_topic_for_topic(topic)
    return unless topic.page_type == "topic"
    if primary_topics.to_a.map(&:id).include?(topic.id)
      primary_topic = topic
    else
      topic.ancestors.each do |ancestor|
        if primary_topics.include?(ancestor)
          primary_topic = ancestor
        end
      end
    end
    primary_topic
  end

  ### --------------------------------------------------------------------------
  ### Projects
  ### --------------------------------------------------------------------------

  def projects_page
    site.pages.find_by_url("projects")
  end

  def projects_for_navigation
    projects_page.children.in_order.visible.published
  end

  ### --------------------------------------------------------------------------
  ### Blog
  ### --------------------------------------------------------------------------

  def blog_page
    site.pages.find_by_url("writings")
  end

  def blog_archive_page
    blog_page.children.of_type("blog_archive").first
  end


  ### --------------------------------------------------------------------------
  ### Broadcasts
  ### --------------------------------------------------------------------------

  def broadcasts_page
    site.pages.find_by_url("broadcasts")
  end

  def broadcasts_archive_page
    broadcasts_page.children.of_type("broadcasts_archive").first
  end

  def main_podcast
    site.pages.find_by_url("broadcasts/podcasts/the-wheeler-centre")
  end

  def rss_url_for_podcast(series, options={})
    return unless series.page_type == "podcast_series"
    options.reverse_merge!(type: "audio")
    "#{series.absolute_url}.rss?type=#{options[:type]}"
  end

  ### --------------------------------------------------------------------------
  ### Events
  ### --------------------------------------------------------------------------

  def events_page
    site.pages.find_by_url("events")
  end

  def upcoming_events_for_navigation
    events_page.upcoming_events(per_page: 5)
  end

  def days_for_week(week)
    (0..6).map {|d| week + d.days}
  end

  # As heard on "Chroma Zone" talk by Lea Verou
  # Explanation @ http://www.w3.org/TR/2014/NOTE-WCAG20-TECHS-20140311/G18
  # @color - [r,g,b]

  def valid_hex_color(hex_color)
    hex_color =~ /(^#?[0-9A-Fa-f]{6}$)|(^#?[0-9A-Fa-f]{3}$)/
  end

  def hex_to_rgb(hex_color)
    hex_color = hex_color || "#cccccc"
    hex_color = hex_color.gsub(/^#/, '')
    hex_color.scan(/.{2}/).map {|color| color.to_i(16)}
  end

  def luminance(color)
    rgb = color.map do |c|
      c = c / 255.0 # to 0-1 range
      (c < 0.03928) ? c / 12.92 : (c+0.055)/1.055 ** 2.4
    end
    return 21.26 * rgb[0] + 71.52 * rgb[1] + 7.22 * rgb[2]
  end

  def style_for_event_series_block(highlight_color)
    if highlight_color.present?
      highlight_color = highlight_color.gsub(/^#/, '')
      text_color = Color::RGB.by_hex(highlight_color)
      range = luminance(hex_to_rgb(highlight_color))
      text_color = if range > 60
        text_color.darken_by(10).css_rgb
      else
        text_color.lighten_by(2).css_rgb
      end
      "background-color: ##{highlight_color}; color: #{text_color}"
    end
  end

  def dark_color_for_highlight_color(highlight_color)
    if highlight_color.present?
      text_color = Color::RGB.by_hex(highlight_color)
      text_color.darken_by(55).adjust_saturation(100).css_rgb
    end
  end

  ### --------------------------------------------------------------------------
  ### General page helpers
  ### --------------------------------------------------------------------------

  def descendant_of(page, ancestor)
    page.ancestor_ids.include?(ancestor.id)
  end

  def is_or_is_descendant_of(page, ancestor)
    (page.id == ancestor.id || descendant_of(page, ancestor))
  end



end
