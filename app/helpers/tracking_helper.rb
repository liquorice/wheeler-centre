module TrackingHelper
  def event_url(target, options={})
    track_event_path(location: url_with_domain(page.absolute_url),
      title: page.title, path: page.absolute_url, target: target,
      category: options[:category], track_action: options[:track_action])
  end

  def pageview_url(target)
    track_pageview_path(location: target, title: page.title,
      path: page.absolute_url)
  end

  def social_url(target, options={})
    track_social_path(location: url_with_domain(page.absolute_url),
      title: page.title, path: page.absolute_url, target: target,
      track_action: options[:action], network: options[:network])
  end
end
