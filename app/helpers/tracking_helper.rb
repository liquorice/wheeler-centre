require 'uri'

module TrackingHelper
  DEFAULT_CAMPAIGN_ID = "external_tracking"

  # Generate a tracking URL for an event such as a file download or podcast subscription
  #
  # url - The URL for which you want to track events
  # options - Optional parameters for the event to be recorded in Google Analytics
  #   - format: "image" if generating a tracking image
  #   - location: notionally the full URL for the page (eg http://localhost:5000/broadcasts/podcasts/the-fifth-estate/the-fifth-estate)
  #   - title: notionally the page title (eg The Fifth Estate)
  #   - path: notionally the page path (eg /broadcasts/podcasts/the-fifth-estate)
  #   - category: the category of the event (eg file, podcast)
  #   - event_action: the action being tracked (eg download, subscribe)
  #
  # Example:
  # track_event(http://localhost:5000/broadcasts/podcasts/the-fifth-estate.rss,
  #   location: "http://localhost:5000/broadcasts/podcasts/the-fifth-estate", title: "The Fifth Estate",
  #   path: "/broadcasts/podcasts/the-fifth-estate", category: "podcast", event_action: "subscribe")
  #
  # Returns an event tracking URL
  def track_event(url, options = {})
    if permitted_tracking_host?(url)
      if options[:format] == "image"
        track_event_image_path(
          target: url,
          location: options[:location] || url,
          title: options[:title],
          path: options[:path] || path_for_url(url),
          event_category: options[:event_category],
          event_action: options[:event_action],
          event_label: options[:event_label] || url
        )
      else
        track_event_path(
          target: url,
          location: options[:location],
          title: options[:title],
          path: options[:path] || path_for_url(url),
          event_category: options[:event_category],
          event_action: options[:event_action],
          event_label: options[:event_label] || url
        )
      end
    else
      url
    end
  end

  def track_event_for_asset(asset, options = {})
    url = asset.original_url
    options = {
      title: options[:title] || title_for_asset(asset),
      path: options[:path] || path_for_url(url)
    }.merge(options)
    track_event(url, options)
  end

  def track_event_for_page(page, options = {})
    path = page.absolute_url
    url = url_with_domain(path)
    options = {
      title: options[:title] || page.title,
      path: options[:path] || path
    }.merge(options)
    track_event(url, options)
  end

  # Generate a tracking URL for a pageview
  #
  # url - The URL for which you want to track pageviews
  # options - Optional parameters for the pageview to be recorded in Google Analytics
  #   - format: "image" if generating a tracking image
  #   - location: notionally the full URL for the page (eg http://localhost:5000/broadcasts/podcasts/the-fifth-estate/the-fifth-estate)
  #   - title: notionally the page title (eg The Fifth Estate)
  #   - path: notionally the page path (eg /broadcasts/podcasts/the-fifth-estate)
  #   - campaign_id: differentiates pageviews tracked via this method - notionally "external_tracking"
  #
  # Example:
  # track_pageview(http://localhost:5000/broadcasts/podcasts/the-fifth-estate,
  #   location: http://localhost:5000/broadcasts/podcasts/the-fifth-estate", title: "The Fifth Estate",
  #   path: "/broadcasts/podcasts/the-fifth-estate", campaign_id: "external_tracking"
  #
  # Returns a pageview tracking URL for use where the Google Analytics JS can't be executed (eg in an RSS reader)
  def track_pageview(url, options = {})
    if permitted_tracking_host?(url)
      if options[:format] == "image"
        track_pageview_image_path(
          target: url,
          location: options[:location] || url,
          title: options[:title],
          path: options[:path] || path_for_url(url),
          campaign_id: options[:campaign_id] || DEFAULT_CAMPAIGN_ID
        )
      else
        track_pageview_path(
          target: url,
          location: options[:location] || url,
          title: options[:title],
          path: options[:path] || path_for_url(url),
          campaign_id: options[:campaign_id] || DEFAULT_CAMPAIGN_ID
        )
      end
    else
      url
    end
  end

  def track_pageview_for_asset(asset, options = {})
    url = asset.original_url
    options = {
      title: options[:title] || title_for_asset(asset),
      path: options[:path] || path_for_url(url)
    }.merge(options)
    track_pageview(url, options)
  end

  def track_pageview_for_page(page, options = {})
    path = page.absolute_url
    url = url_with_domain(path)
    options = {
      title: options[:title] || page.title,
      path: options[:path] || path
    }.merge(options)
    track_pageview(url, options)
  end

  # Generate a tracking URL for a social interaction
  #
  # url - The URL for which you want to track social interactions
  # options - Optional parameters for the social interaction to be recorded in Google Analytics
  #   - format: "image" if generating a tracking image
  #   - location: notionally the full URL (eg http://localhost:5000/broadcasts/podcasts/the-fifth-estate/the-fifth-estate)
  #   - title: notionally the page title (eg The Fifth Estate)
  #   - path: notionally the page path (eg /broadcasts/podcasts/the-fifth-estate)
  #   - event_action (REQUIRED) - the action being tracked (eg share, like)
  #   - social_network (REQUIRED) - social network (eg twitter, facebook)
  #
  # Example:
  # track_social(https://twitter.com/home?status=http://localhost:5000/broadcasts/podcasts/the-fifth-estate,
  #   location: http://localhost:5000/broadcasts/podcasts/the-fifth-estate", title: "The Fifth Estate",
  #   path: "/broadcasts/podcasts/the-fifth-estate", event_action: "share", network: "twitter"
  #
  # Returns a social interaction tracking URL
  def track_social(url, options = {})
    if permitted_tracking_host?(url)
      if options[:format] == "image"
        track_social_image_path(
          target: url,
          location: options[:location] || url,
          title: options[:title],
          path: options[:path] || path_for_url(url),
          social_action: options[:social_action],
          social_network: options[:social_network]
        )
      else
        track_social_path(
          target: url,
          location: options[:location] || url,
          title: options[:title],
          path: options[:path] || path_for_url(url),
          social_action: options[:social_action],
          social_network: options[:social_network]
        )
      end
    else
      url
    end
  end

  def track_social_for_asset(asset, options = {})
    url = asset.original_url
    options = {
      title: options[:title] || title_for_asset(asset),
      path: options[:path] || path_for_url(url)
    }.merge(options)
    track_social(url, options)
  end

  def track_social_for_page(page, options = {})
    path = page.absolute_url
    url = url_with_domain(path)
    options = {
      title: options[:title] || page.title,
      path: options[:path] || path
    }.merge(options)
    track_social(url, options)
  end

  def permitted_tracking_host?(url)
    ENV["PERMITTED_TRACKING_HOSTS"].to_s.split(",").any? { |h| url.include? h }
  end

  private

  def path_for_url(url)
    URI::parse(url).path
  end

  def title_for_asset(asset)
    unless asset.title.blank?
      asset.title
    else
      asset.file_name
    end
  end
end
