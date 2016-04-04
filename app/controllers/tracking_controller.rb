class TrackingController < ActionController::Metal
  include ActionController::Redirecting
  include ActionController::DataStreaming
  include AbstractController::Callbacks
  include AbstractController::Rendering

  before_action :setup_tracker

  def event
    begin
      @tracker.event(
        document_location: params[:location],
        document_title: params[:title],
        document_path: params[:path],
        category: params[:event_category],
        action: params[:event_action],
        label: params[:event_label])
    rescue => e
      Rails.logger.error "An error occurred connecting to Google Analytics - #{e}"
    end
    if params[:format] == "png"
      send_blank_image
    else
      redirect_to target, status: params[:status].presence || 302
    end
  end

  def pageview
    begin
      @tracker.pageview(
        document_location: params[:location],
        document_title: params[:title],
        document_path: params[:path],
        campaign_id: params[:campaign_id])
    rescue => e
      Rails.logger.error "An error occurred connecting to Google Analytics - #{e}"
    end
    if params[:format] == "png"
      send_blank_image
    else
      redirect_to target, status: params[:status].presence || 302
    end
  end

  def social
    begin
      @tracker.social(
        document_location: params[:location],
        document_title: params[:title],
        document_path: params[:path],
        action: params[:social_action],
        network: params[:network],
        target: target)
    rescue => e
      Rails.logger.error "An error occurred connecting to Google Analytics - #{e}"
    end
    redirect_to target, status: params[:status].presence || 302
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

  # We changed the `target` param to `_target` to ensure it's sorted first
  # by Rails' URL helpers. We want it first because these tracking URLs get
  # truncated occasionally by stupid systems that assume URLs can only be 255
  # character. With the _target first they'll at least redirect correctly even
  # if they don't get tracked.
  def target
    params[:_target] || params[:target]
  end

end
