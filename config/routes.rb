Rails.application.routes.draw do

  devise_for :users

  WheelerCentre::Application.routes.draw do
	  mount Heracles::Admin::Engine, at: "/admin"
	end
end
