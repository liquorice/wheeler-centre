Rails.application.routes.draw do
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
      resources :sites do
        resources :bulk_publication
      end
    end
  end

  # Handle 404 and 500 errors
  match "/404", :to => "not_found#show", as: "not_found", via: :all
  match "/500", :to => "exceptions#show", as: "exception", via: :all

  # Reactive Cache Buster
  get '_check/*edge_url/_check.js' => "cache_buster#index", as: :cache_buster_check

  # Admin
  resource :admin, only: [:show]

  # Search pages
  resource :search, only: [:show]

  # Heracles public pages.
  post "*path/__preview" => "pages#show", preview: true
  get "*path" => "pages#show"
  root to: "pages#show"
end
