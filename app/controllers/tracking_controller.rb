class TrackingController < ActionController::Metal
  include ActionController::Redirecting
  include ActionController::DataStreaming
  include AbstractController::Callbacks
  include AbstractController::Rendering

  before_action :setup_tracker
  before_filter :set_cache_headers_for_page


  def event
    @tracker.event(
      document_location: params[:location],
      document_title: params[:title],
      document_path: params[:path],
      category: params[:event_category],
      action: params[:event_action],
      label: params[:event_label])
    if params[:format] == "png"
      send_blank_image
    else
      redirect_to params[:target], status: params[:status].presence || 302
    end
  end

  def pageview
    @tracker.pageview(
      document_location: params[:location],
      document_title: params[:title],
      document_path: params[:path],
      campaign_id: params[:campaign_id])
    if params[:format] == "png"
      send_blank_image
    else
      redirect_to params[:target], status: params[:status].presence || 302
    end
  end

  def social
    @tracker.social(
      document_location: params[:location],
      document_title: params[:title],
      document_path: params[:path],
      action: params[:social_action],
      network: params[:network],
      target: params[:target])
    redirect_to params[:target], status: params[:status].presence || 302
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

  def send_blank_image
    send_data(
      Base64.decode64("iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVQYV2NgYAAAAAMAAWgmWQ0AAAAASUVORK5CYII="),
      type: "image/png", disposition: "inline"
    )
  end

  def set_cache_headers_for_page
    if Rails.env.production?
      response.headers["Surrogate-Control"] = "max-age=#{1.day.to_i}"
      response.headers["Cache-Control"] = "max-age=300, public"
      # Remove "Set-Cookie" header
      request.session_options[:skip] = true
    end
  end
end
