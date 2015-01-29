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

  ### Application specific helpers

  def excerptify(text, chars = 220)
    text = strip_tags(text)
    truncate(text, length: chars)
  end

  def force_excerptify_html(html, length = 350, allowed_tags = "p i em strong br")
    truncate_html(
      Sanitize.fragment(html, Sanitize::Config.merge(Sanitize::Config::RESTRICTED,
        :elements => Sanitize::Config::RESTRICTED[:elements] + allowed_tags.split(" "),
      )),
    length: length)
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


  # Set of primary tags/categories that content falls under
  def topics_page
    site.pages.find_by_url("topics")
  end

  def primary_topics
    topics_page.children.visible.published.of_type("topic")
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

end
