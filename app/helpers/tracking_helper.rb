module TrackingHelper
  PERMITTED_HOSTS = %w(
    localhost
  ).freeze

  # Generate a tracking URL for an event such as a file download or podcast subscription
  #
  # target - The URL for which you want to track events
  # options - Optional parameters for the event to be recorded in Google Analytics
  #   - location: notionally the full URL for the page (eg http://localhost:5000/broadcasts/podcasts/the-fifth-estate/the-fifth-estate)
  #   - title: notionally the page title (eg The Fifth Estate)
  #   - path: notionally the page path (eg /broadcasts/podcasts/the-fifth-estate)
  #   - category: the category of the event (eg file, podcast)
  #   - track_action: the action being tracked (eg download, subscribe)
  #
  # Example:
  # track_event_url(http://localhost:5000/broadcasts/podcasts/the-fifth-estate.rss,
  #   location: "http://localhost:5000/broadcasts/podcasts/the-fifth-estate", title: "The Fifth Estate",
  #   path: "/broadcasts/podcasts/the-fifth-estate", category: "podcast", track_action: "subscribe")
  #
  # Returns an event tracking URL
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

  # Generate a tracking URL for a pageview
  #
  # target - The URL for which you want to track pageviews
  # options - Optional parameters for the pageview to be recorded in Google Analytics
  #   - location: notionally the full URL for the page (eg http://localhost:5000/broadcasts/podcasts/the-fifth-estate/the-fifth-estate)
  #   - title: notionally the page title (eg The Fifth Estate)
  #   - path: notionally the page path (eg /broadcasts/podcasts/the-fifth-estate)
  #   - campaign_id: differentiates pageviews tracked via this method - notionally "external_tracking"
  #
  # Example:
  # track_pageview_url(http://localhost:5000/broadcasts/podcasts/the-fifth-estate,
  #   location: http://localhost:5000/broadcasts/podcasts/the-fifth-estate", title: "The Fifth Estate",
  #   path: "/broadcasts/podcasts/the-fifth-estate", campaign_id: "external_tracking"
  #
  # Returns a pageview tracking pixel for use where the Google Analytics JS can't be executed (eg in an RSS reader)
  def track_pageview_url(target)
    if PERMITTED_HOSTS.any? { |h| target.include? h }
      url = track_pageview_path(
        location: options[:location],
        title: options[:title],
        path: options[:path],
        campaign_id: options[:campaign_id])
      raw("<img src=#{url} width=1 height=1>")
    else
      target
    end
  end

  # Generate a tracking URL for a social interaction
  #
  # target - The URL for which you want to track social interactions
  # options - Optional parameters for the social interaction to be recorded in Google Analytics
  #   - location: notionally the full URL (eg http://localhost:5000/broadcasts/podcasts/the-fifth-estate/the-fifth-estate)
  #   - title: notionally the page title (eg The Fifth Estate)
  #   - path: notionally the page path (eg /broadcasts/podcasts/the-fifth-estate)
  #   - track_action (REQUIRED) - the action being tracked (eg share, like)
  #   - network (REQUIRED) - social network (eg twitter, facebook)
  #
  # Example:
  # track_social_url(https://twitter.com/home?status=http://localhost:5000/broadcasts/podcasts/the-fifth-estate,
  #   location: http://localhost:5000/broadcasts/podcasts/the-fifth-estate", title: "The Fifth Estate",
  #   path: "/broadcasts/podcasts/the-fifth-estate", track_action: "share", network: "twitter"
  #
  # Returns a social interaction tracking URL
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
