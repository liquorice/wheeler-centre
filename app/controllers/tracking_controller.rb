class TrackingController < ApplicationController
  def event
    category = params[:category]
    action = params[:action]
    label = params[:label]
    value = params[:value]
    tracker = Staccato.tracker(ENV["GA_TRACKING_ID"])
    event = tracker.build_event(category: category, action: action, label: label, value: value)
    event.track!

    # http://localhost:5000/_track/event/?category=file&action=download&label=downloadat1800&value=1800
  end

  def pageview
    location = params[]
    page = params[:request_url]
    title = params[:title]
    tracker = Staccato.tracker(ENV["GA_TRACKING_ID"])
    pageview = tracker.build_pageview(location, page, title)
    pageview.track!
  end

  def social
    social_network
    social_action
    social_target
    tracker = Staccato.tracker(ENV["GA_TRACKING_ID"])
    social = tracker.build_social(social_network, social_action, social_target)
    social.track!
  end
end
