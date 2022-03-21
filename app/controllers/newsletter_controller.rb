class NewsletterController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def subscribe
    unless verify_recaptcha?(params[:recaptcha_token], 'letter')
      flash.now[:error] = "reCAPTCHA Authorization Failed. Please try again later."
      redirect_to root_path and return
    end
    
    uri = URI.parse("https://tracking.wordfly.com/join/wheelercentre")
    data = {
      :Email => params['Email'],
      :FirstName => params['FirstName'],
      :LastName => params['LastName']}
    results = Net::HTTP.post_form(uri, data)
    
    uri = URI.parse("https://tracking.wordfly.com/join/wheelercentre/submitted")
    results = Net::HTTP.get(uri)

    render html: results.html_safe
  end
end
