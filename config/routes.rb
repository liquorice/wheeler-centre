Rails.application.routes.draw do

  devise_for :users

  WheelerCentre::Application.routes.draw do
	  # Heracles admin
	  mount Heracles::Admin::Engine, at: "/admin"

	  # Admin
	  resource :admin, only: [:show]
	end
end
