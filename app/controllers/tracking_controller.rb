class TrackingController < ActionController::Metal
  include ActionController::Redirecting
  include AbstractController::Callbacks

  before_action :setup_tracker

  def event
    @tracker.event(
      document_location: params[:location],
      document_title: params[:title],
      document_path: params[:path],
      category: params[:category],
      action: params[:track_action],
      label: params[:label])
    redirect_to params[:target]
  end

  def pageview
    @tracker.pageview(
      document_location: params[:location],
      document_title: params[:title],
      document_path: params[:path],
      campaign_id: params[:campaign_id])
  end

  def social
    @tracker.social(
      document_location: params[:location],
      document_title: params[:title],
      document_path: params[:path],
      action: params[:track_action],
      network: params[:network],
      target: params[:target])
    redirect_to params[:target]
  end

  private

  def setup_tracker
    @tracker = Staccato.tracker(ENV["GA_TRACKING_ID"], ga_client_id)
  end

  def ga_client_id
    ga_cookie.split(".").last(2).join(".") if ga_cookie.present?
  end

  def ga_cookie
    request.cookies["_ga"]
  end
end
