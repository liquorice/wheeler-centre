class TrackingController < ActionController::Metal
  include ActionController::Redirecting
  include Rails.application.routes.url_helpers

  def event
    tracker = Staccato.tracker(ENV["GA_TRACKING_ID"])
    tracker.event(
      document_location: params[:location],
      document_title: params[:title],
      document_path: params[:path],
      category: params[:category],
      action: params[:track_action],
      label: params[:label])
    redirect_to params[:target]
  end

  def pageview
    tracker = Staccato.tracker(ENV["GA_TRACKING_ID"])
    tracker.pageview(
      location: params[:location],
      title: params[:title],
      path: params[:path],
      campaign_id: params[:campaign_id])
  end

  def social
    tracker = Staccato.tracker(ENV["GA_TRACKING_ID"])
    tracker.social(
      document_location: params[:location],
      document_title: params[:title],
      document_path: params[:path],
      action: params[:track_action],
      network: params[:network],
      target: params[:target])
    redirect_to params[:target]
  end
end
