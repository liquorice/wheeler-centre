module TrackingHelper
  PERMITTED_HOSTS = %w(
    localhost
  ).freeze

  def track_event_url(target, options = {})
    if PERMITTED_HOSTS.any? { |h| target.include? h }
      track_event_path(
        target: target,
        location: options[:location],
        title: options[:title],
        path: options[:path],
        category: options[:category],
        track_action: options[:track_action],
        label: target)
    else
      target
    end
  end

  def track_pageview_url(target)
    if PERMITTED_HOSTS.any? { |h| target.include? h }
      url = track_pageview_path(
        location: options[:location],
        title: options[:title],
        path: options[:path],
        campaign_id: "png")
      raw("<img src=#{url} width=1 height=1>")
    else
      target
    end
  end

  def track_social_url(target, options = {})
    if PERMITTED_HOSTS.any? { |h| target.include? h }
      track_social_path(
        target: target,
        location: options[:location],
        title: options[:title],
        path: options[:path],
        track_action: options[:action],
        network: options[:network])
    else
      target
    end
  end
end
