Rails.application.routes.draw do
  # Heracles admin
  mount Heracles::Admin::Engine, at: "/admin"

  # Additional Heracles admin routes
  Heracles::Admin::Engine.routes.draw do
    scope constraints: Heracles::Admin::AdminHostConstraint do
      namespace :api do
        resources :sites do
          namespace :fields do
            resources :external_video, only: :index
          end
        end
      end
    end
  end

  # Reactive Cache Buster
  #mount CacheBuster::App.new, at: '/buster', as: :buster

  # Admin
  resource :admin, only: [:show]

  # Heracles public pages.
  post "*path/__preview" => "pages#show", preview: true
  get "*path" => "pages#show"
  root to: "pages#show"
end
