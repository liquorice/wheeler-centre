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
  #   - action: the action being tracked (eg download, subscribe)
  #   - label: the label being tracked (default to url)
  #
  # Example:
  # track_event(http://localhost:5000/broadcasts/podcasts/the-fifth-estate.rss,
  #   location: "http://localhost:5000/broadcasts/podcasts/the-fifth-estate", title: "The Fifth Estate",
  #   path: "/broadcasts/podcasts/the-fifth-estate", category: "podcast", action: "subscribe")
  #
  # Returns an event tracking URL
  def track_event(url, options = {})
    if permitted_tracking_host?(url)
      tracking_params = {
        target: url,
        redirect: options[:redirect],
        location: options[:location] || url,
        title: options[:title],
        path: options[:path] || path_for_url(url),
        category: options[:category],
        action: options[:action],
        label: options[:label] || url
      }

      track_event_url(tracking_params, options[:format])
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
      tracking_params = {
        target: url,
        redirect: options[:redirect],
        location: options[:location] || url,
        title: options[:title],
        path: options[:path] || path_for_url(url),
        campaign_id: options[:campaign_id] || DEFAULT_CAMPAIGN_ID
      }

      track_pageview_url(tracking_params, options[:format])
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
  #   - action (REQUIRED) - the action being tracked (eg share, like)
  #   - network (REQUIRED) - social network (eg twitter, facebook)
  #
  # Example:
  # track_social(https://twitter.com/intent/tweet?url=http://localhost:5000/broadcasts/podcasts/the-fifth-estate,
  #   location: http://localhost:5000/broadcasts/podcasts/the-fifth-estate", title: "The Fifth Estate",
  #   path: "/broadcasts/podcasts/the-fifth-estate", action: "share", network: "twitter"
  #
  # Returns a social interaction tracking URL
  def track_social(url, options = {})
    if permitted_tracking_host?(url)
      tracking_params = {
        target: url,
        redirect: options[:redirect],
        location: options[:location] || url,
        title: options[:title],
        path: options[:path] || path_for_url(url),
        action: options[:action],
        network: options[:network]
      }

      track_social_url(tracking_params, options[:format])
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
    URI.parse(URI.escape(url)).path
  end

  def title_for_asset(asset)
    unless asset.title.blank?
      asset.title
    else
      asset.file_name
    end
  end

  def tracking_server_base_url
    ENV["TRACKING_SERVER_BASE_URL"]
  end

  def track_event_url(params, format = nil)
    params = URI.encode_www_form(params.compact)
    path =
      case format
      when "image"
        "event.png"
      when "audio"
        "event.mp3"
      when "video"
        "event.mov"
      else
        "event"
      end

    "#{tracking_server_base_url}/#{path}?#{params}"
  end

  def track_pageview_url(params, format = nil)
    params = URI.encode_www_form(params.compact)
    path =
      case format
      when "image"
        "pageview.png"
      when "audio"
        "pageview.mp3"
      when "video"
        "pageview.mov"
      else
        "pageview"
      end

    "#{tracking_server_base_url}/#{path}?#{params}"
  end

  def track_social_url(params, format = nil)
    params = URI.encode_www_form(params.compact)
    path =
      case format
      when "image"
        "social.png"
      when "audio"
        "social.mp3"
      when "video"
        "social.mov"
      else
        "social"
      end

    "#{tracking_server_base_url}/#{path}?#{params}"
  end
end
