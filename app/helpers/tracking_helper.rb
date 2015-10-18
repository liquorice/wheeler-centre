module TrackingHelper
  PERMITTED_HOSTS = %w(
    localhost
  ).freeze

  def event_url(target, options = {})
    if PERMITTED_HOSTS.any? { |h| target.include? h }
      track_event_path(
        location: url_with_domain(page.absolute_url),
        title: page.title,
        path: page.absolute_url,
        target: target,
        category: options[:category],
        track_action: options[:track_action],
        label: target)
    else
      target
    end
  end

  def pageview_url(target)
    if PERMITTED_HOSTS.any? { |h| target.include? h }
      url = track_pageview_path(
        location: url_with_domain(page.absolute_url),
        title: page.title,
        path: page.absolute_url,
        campaign_id: "png")
      raw("<img src=#{url}, width=1, height=1>")
    else
      target
    end
  end

  def social_url(target, options = {})
    if PERMITTED_HOSTS.any? { |h| target.include? h }
      track_social_path(
        location: url_with_domain(page.absolute_url),
        title: page.title,
        path: page.absolute_url,
        target: target,
        track_action: options[:action],
        network: options[:network])
    else
      target
    end
  end
end
