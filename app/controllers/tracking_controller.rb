class TrackingController < ActionController::Metal
  include ActionController::Redirecting

  def event
    tracker = Staccato.tracker(ENV["GA_TRACKING_ID"])
    event = tracker.build_event(
      category: params[:category],  #file, #podcast
      action: params[:action],      #download, #subscribe
      label: params[:label],        #Title+of+pdf, #Title+of+podcast
      value: params[:value])        #link to file, #link to rss
    event.track!
    redirect_to(params[:value])

    # http://localhost:5000/_track/event/?category=podcast&action=subscribe&label=The+Wheeler+Centre&value=feed://localhost:5000/broadcasts/podcasts/the-wheeler-centre.rss
  end

  def pageview
    tracker = Staccato.tracker(ENV["GA_TRACKING_ID"])
    pageview = tracker.build_pageview(
      location: params[:location],  #full url
      title: params[:title],        #page title
      page: params[:page])          #page slug
    pageview.track!
    redirect_to params[:location]

    # http://localhost:5000/_track/pageview/?location=http://localhost:5000/notes/the-man-who-wasnt-there&title=The+Man+Who+Wasn’t+There:+investigating+the+disappearance+of+the+boss+of+Barwon+Prison&Page=/the-man-who-wasnt-there
  end

  def social
    tracker = Staccato.tracker(ENV["GA_TRACKING_ID"])
    social = tracker.build_social(
      social_network: params[:social_network],  #facebook
      social_action: params[:social_action],    #like
      social_target: params[:social_target])    #/something
    social.track!
    redirect_to(params[:social_target])

    # http://localhost:5000/_track/social/?social_network=facebook&social_action=like&social_target=
  end
end
