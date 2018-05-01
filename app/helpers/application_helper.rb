module ApplicationHelper
  include Heracles::ContentFieldHelper

  # Common helpers sit under lib/helpers
  include TextFormattingHelper

  def development_javascript
    javascript_include_tag(
      "http://#{ENV['ASSETS_DEVELOPMENT_HOST']}:#{ENV['ASSETS_WEBPACK_PORT']}/webpack-dev-server.js",
      "data-turbolinks-track" => true)
  end

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

    filters ||= custom_filters
    render_content_with_filters(content_field, filters, options)
  end

  def render_content_in_sections(content_field, options={})
    filters = custom_filters + [Heracles::Sites::WheelerCentre::SectionFilter]
    render_content content_field, options, filters
  end

  def custom_filters
    [
      Heracles::ContentFieldRendering::InsertablesFilter,
      Heracles::Sites::WheelerCentre::AssetsFilter,
      Heracles::ContentFieldRendering::PageLinkFilter
    ]
  end

  def canonical_domain
    if ENV["CANONICAL_PROTOCOL"] && ENV["CANONICAL_HOSTNAME"]
      "#{ENV["CANONICAL_PROTOCOL"]}#{ENV["CANONICAL_HOSTNAME"]}#{':' + ENV["CANONICAL_PORT"] unless ENV["CANONICAL_PORT"].blank?}"
    else
      "#{request.protocol}#{request.host_with_port}"
    end
  end

  def url_with_domain(url)
    canonical_domain + "/" + url.gsub(/^\//, '')
  end

  def pcast_url_with_domain(url)
    url_with_domain(url).gsub(/^https?/, "pcast")
  end

  def pcast_url(url)
    url.gsub(/^https?/, "pcast")
  end

  def webcal_url_with_domain(url)
    url_with_domain(url).gsub(/^https?/, "webcal")
  end

  def url_basename(url)
    episode = URI.parse(URI.escape(url)).path.split('/').last
  end

  def human_boolean(bool)
    bool ? "yes" : "no"
  end

  def duration_to_hms(duration, options={})
    trim_hours = options[:trim_hours] || false
    format = trim_hours ? "%M:%S" : "%H:%M:%S"
    Time.at(duration).utc.strftime(format)
  end

  ### Application specific helpers

  def excerptify(text, chars = 220)
    text = strip_tags(text)
    truncate(text, length: chars)
  end

  def force_excerptify_html(html, words = 50, allowed_tags = "p i em strong br")
    HTML_Truncator.truncate(
      strip_html(html, allowed_tags),
    words).html_safe
  end

  def strip_html(html, allow_tags = "p i em strong br", allow_attributes = {}, remove_contents: false)
    Sanitize.fragment(html, Sanitize::Config.merge(Sanitize::Config::RESTRICTED,
      :elements => allow_tags.split(" "),
      :attributes => allow_attributes,
      :remove_contents => remove_contents
    ))
  end

  def replace_absolute_links_with_canonical_domain(html)
    doc = Nokogiri::HTML::DocumentFragment.parse html
    links = doc.css("[href^='/']:not([href^='//'])")
    links.each do |link|
      link.attributes["href"].value = canonical_domain + link.attributes["href"].value
    end
    srcs = doc.css("[src^='/']:not([src^='//'])")
    srcs.each do |src|
      src.attributes["src"].value = canonical_domain + src.attributes["src"].value
    end
    doc.to_html
  end

  # Cribbed from Padrino:
  # http://rubydoc.info/github/padrino/padrino-framework/master/Padrino/Helpers/AssetTagHelpers:favicon_tag
  def favicon_tag(source, options={})
    type = File.extname(source).gsub('.','')
    options = options.dup.reverse_merge!(:href => image_path(source), :rel => 'icon', :type => "image/#{type}")
    tag(:link, options)
  end

  def format_date(start_date, end_date, options={})
    return "" unless start_date.present?
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
        display_date += ", #{I18n.l(start_date, format: :time_only)}-#{I18n.l(end_date, format: :time_only)}"
      end
    else
      display_date = "#{I18n.l(start_date, format: format)}—#{I18n.l(end_date, format: format)}"
    end
    display_date
  end

  def indefinite_article_for_number(number)
    vowels = %w( a e i u )
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

  memoize \
  def projects_page
    site.pages.find_by_url("projects")
  end

  memoize \
  def projects_for_navigation
    projects_page.children.in_order.visible.published
  end

  ### --------------------------------------------------------------------------
  ### Notes
  ### --------------------------------------------------------------------------

  memoize \
  def notes_page
    site.pages.of_type("longform_blog").first
  end

  ### --------------------------------------------------------------------------
  ### People
  ### --------------------------------------------------------------------------

  memoize \
  def people_page
    site.pages.of_type("people").first
  end

  ### --------------------------------------------------------------------------
  ### Blog
  ### --------------------------------------------------------------------------

  memoize \
  def blog_page
    site.pages.of_type("blog").first
  end

  memoize \
  def blog_archive_page
    blog_page.children.of_type("blog_archive").first
  end

  ### --------------------------------------------------------------------------
  ### Longform Blog
  ### --------------------------------------------------------------------------

  memoize \
  def longform_blog_page
    site.pages.of_type("longform_blog").first
  end

  memoize \
  def longform_blog_archive_page
    site.pages.of_type("longform_blog_archive").first
  end

  ### --------------------------------------------------------------------------
  ### The Next Chapter
  ### --------------------------------------------------------------------------

  memoize \
  def next_chapter_home_page
    site.pages.of_type("next_chapter_home_page").first
  end

  ### --------------------------------------------------------------------------
  ### Broadcasts
  ### --------------------------------------------------------------------------

  memoize \
  def broadcasts_page
    site.pages.of_type("broadcasts").first
  end

  memoize \
  def broadcasts_archive_page
    broadcasts_page.children.of_type("broadcasts_archive").first
  end

  def rss_url_for_podcast(series, options={})
    return unless series.page_type == "podcast_series"
    options.reverse_merge!(type: "audio")
    "#{series.absolute_url}.rss?type=#{options[:type]}"
  end

  def podcast_tracking_link(series, type = nil)
    url = "#{url_with_domain(series.absolute_url)}.rss"
    url = "#{url}?type=#{type}" if type
    track_event(url, { \
      label: "#{series.title}, #{url}", \
      category: "podcast", \
      action: "subscribe", \
      title: "Podcast: #{series.title}" \
    })
  end

  def page_title_for_podcast(podcast)
    title = ""
    if podcast.series.present?
      title = "#{podcast.series.title}: "
    end
    "#{title}#{podcast.title}"
  end

  ### --------------------------------------------------------------------------
  ### Events
  ### --------------------------------------------------------------------------

  memoize \
  def events_page
    site.pages.of_type("events").first
  end

  memoize \
  def upcoming_events_for_navigation
    events_page.upcoming_events_except_cancelled(per_page: 5)
  end

  def days_for_week(week)
    (0..6).map {|d| week + d.days}
  end

  def page_title_for_event(event)
    title = ""
    if event.series
      title = "#{event.series.title}: "
    end
    title += "#{event.title}"
    if event.fields[:start_date].data_present?
      title += ", #{format_date(event.fields[:start_date].value_in_time_zone, event.fields[:end_date].value_in_time_zone, format: "medium_date")}"
    end
    title
  end

  def bookings_open(page)
    !page.fields[:bookings_open_at].data_present? || page.fields[:bookings_open_at].value < Time.zone.now
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


  def add_timezone_entry(event, cal)
    require 'icalendar/tzinfo'
    event_start = event.fields[:start_date].value_in_time_zone
    tzid =  event_start.time_zone.tzinfo.name
    tz = TZInfo::Timezone.get tzid
    timezone = tz.ical_timezone event_start
    cal.add_timezone timezone if !cal.find_timezone(tzid)
  end

  def add_ical_entry(event, cal)
    cal.event do |entry|
      event_start = event.fields[:start_date].value_in_time_zone
      event_end = event.fields[:end_date].value_in_time_zone
      tzid = event_start.time_zone.tzinfo.name

      entry.dtstart = Icalendar::Values::DateTime.new event_start, 'tzid' => tzid
      entry.dtend   = Icalendar::Values::DateTime.new event_end, 'tzid' => tzid if event_end.present?
      entry.summary = event.title
      entry.description = force_excerptify_html(event.fields[:body], 100, "") if event.fields[:body].data_present?
      entry.location = event.venue.title if event.venue.present?
      entry.created = event.created_at
      entry.last_modified = event.updated_at
      entry.url = event.url = url_with_domain(event.absolute_url)
    end
  end

  def ical_calendar(events)
    calendar = Icalendar::Calendar.new
    events.each do |event|
      add_timezone_entry(event, calendar)
      add_ical_entry(event, calendar)
    end
    calendar.append_custom_property("X-WR-CALNAME", "Wheeler Centre events calendar")
    calendar.publish
    calendar.to_ical
  end

  ### --------------------------------------------------------------------------
  ### Settings page
  ### --------------------------------------------------------------------------

  memoize \
  def settings_page
    site.pages.of_type("settings").first
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

  ### --------------------------------------------------------------------------
  ### Flarum discussions
  ### --------------------------------------------------------------------------

  def discussion_title_for(page)
    if page.page_type == "blog_post"
      discussion_title_for_blog_post(page)
    elsif page.page_type == "event"
      discussion_title_for_event(page)
    elsif page.page_type == "recording"
      discussion_title_for_recording(page)
    elsif page.page_type == "podcast_episode"
      discussion_title_for_podcast_episode(page)
    else
      CGI.unescapeHTML(truncate(page.title, length: 80).to_str)
    end
  end

  def discussion_title_for_blog_post(page)
    CGI.unescapeHTML(truncate("Notes: #{strip_tags(page.title)}", length: 80).to_str)
  end

  def discussion_title_for_event(page)
    CGI.unescapeHTML(truncate("Events: #{strip_tags(page.title)}", length: 80).to_str)
  end

  def discussion_title_for_recording(page)
    CGI.unescapeHTML(truncate("Recording: #{strip_tags(page.title)}", length: 80).to_str)
  end

  def discussion_title_for_podcast_episode(page)
    CGI.unescapeHTML(truncate("Podcast: #{strip_tags(page.title)}", length: 80).to_str)
  end

  # Returns Markdown
  def discussion_content_for(page)
    content = ""
    if page.page_type == "blog_post"
      content += discussion_content_for_blog_post(page)
    elsif page.page_type == "event"
      content += discussion_content_for_event(page)
    elsif page.page_type == "recording"
      content += discussion_content_for_recording(page)
    elsif page.page_type == "podcast_episode"
      content += discussion_content_for_podcast_episode(page)
    end
    content += "\n\n"
    content += "This is a companion discussion to the [original post on our website](#{url_with_domain(page.absolute_url)})."
    CGI.unescapeHTML(content.to_str)
  end

  def discussion_content_for_blog_post(page)
    "> #{strip_tags(page.fields[:summary].value)}".gsub(/&nbsp;/, " ")
  end

  def discussion_content_for_event(page)
    "> #{strip_tags(force_excerptify_html(page.fields[:body].value))}".gsub(/&nbsp;/, " ")
  end

  def discussion_content_for_recording(page)
    "> #{strip_tags(force_excerptify_html(page.fields[:description].value))}".gsub(/&nbsp;/, " ")
  end

  def discussion_content_for_podcast_episode(page)
    "> #{strip_tags(force_excerptify_html(page.fields[:description].value))}".gsub(/&nbsp;/, " ")
  end

  def discussion_url(id)
    "#{("#{ENV["FLARUM_HOST"]}" || "https://discussions.wheelercentre.com")}/d/#{id}"
  end

  def discussion_embed_url(id)
    "#{("#{ENV["FLARUM_HOST"]}" || "https://discussions.wheelercentre.com")}/embed/#{id}?hideFirstPost=1"
  end

end
