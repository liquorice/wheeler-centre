module TrackingHelper
  DEFAULT_CAMPAIGN_ID = "external_tracking"

  # Generate a tracking URL for an event such as a file download or podcast subscription
  #
  # target - The URL for which you want to track events
  # options - Optional parameters for the event to be recorded in Google Analytics
  #   - format: "image" if generating a tracking image
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
  def track_event(target, options = {})
    if permitted_tracking_host?(target)
      if options[:format] == "image"
        track_event_image_path(
          target: target,
          location: options[:location],
          title: options[:title],
          path: options[:path],
          category: options[:category],
          track_action: options[:track_action],
          label: target)
      else
        track_event_path(
          target: target,
          location: options[:location],
          title: options[:title],
          path: options[:path],
          category: options[:category],
          track_action: options[:track_action],
          label: target)
      end
    else
      target
    end
  end

  def track_event_for_asset(asset, options = {})
    url = asset.original_url
    track_event(
      url,
      {
        format: options[:format],
        location: url
      }
    )
  end

  def track_event_for_page(page, options = {})
    url = url_with_domain(page.absolute_url)
    track_event(
      url,
      {
        format: options[:format],
        location: url,
        title: options[:title] || page.title
      }
    )
  end

  # Generate a tracking URL for a pageview
  #
  # target - The URL for which you want to track pageviews
  # options - Optional parameters for the pageview to be recorded in Google Analytics
  #   - format: "image" if generating a tracking image
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
  # Returns a pageview tracking URL for use where the Google Analytics JS can't be executed (eg in an RSS reader)
  def track_pageview(target, options = {})
    if permitted_tracking_host?(target)
      if options[:format] == "image"
        track_pageview_image_path(
          location: options[:location],
          title: options[:title],
          path: options[:path],
          campaign_id: options[:campaign_id] || DEFAULT_CAMPAIGN_ID)
      else
        track_pageview_path(
          location: options[:location],
          title: options[:title],
          path: options[:path],
          campaign_id: options[:campaign_id] || DEFAULT_CAMPAIGN_ID)
      end
    else
      target
    end
  end

  def track_pageview_for_asset(asset, options = {})
    url = asset.original_url
    track_pageview(
      url,
      {
        format: options[:format],
        location: url
      }
    )
  end

  def track_pageview_for_page(page, options = {})
    url = url_with_domain(page.absolute_url)
    track_pageview(
      url,
      {
        format: options[:format],
        location: url,
        title: options[:title] || page.title
      }
    )
  end

  # Generate a tracking URL for a social interaction
  #
  # target - The URL for which you want to track social interactions
  # options - Optional parameters for the social interaction to be recorded in Google Analytics
  #   - format: "image" if generating a tracking image
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
  def track_social(target, options = {})
    if permitted_tracking_host?(target)
      if options[:format] == "image"
        track_social_image_path(
          target: target,
          location: options[:location],
          title: options[:title],
          path: options[:path],
          track_action: options[:action],
          network: options[:network])
      else
        track_social_path(
          target: target,
          location: options[:location],
          title: options[:title],
          path: options[:path],
          track_action: options[:action],
          network: options[:network])
      end
    else
      target
    end
  end

  def track_social_for_asset(asset, options = {})
    url = asset.original_url
    track_social(
      url,
      {
        format: options[:format],
        location: url
      }
    )
  end

  def track_social_for_page(page, options = {})
    url = url_with_domain(page.absolute_url)
    track_social(
      url,
      {
        format: options[:format],
        location: url,
        title: options[:title] || page.title
      }
    )
  end

  def permitted_tracking_host?(target)
    ENV["PERMITTED_TRACKING_HOSTS"].to_s.split(",").any? { |h| target.include? h }
  end
end
