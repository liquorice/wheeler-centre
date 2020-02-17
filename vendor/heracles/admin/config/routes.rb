Heracles::Admin::Engine.routes.draw do
  scope constraints: Heracles::Admin::AdminHostConstraint do
    # Admin screens
    resources :sites do
      resources :pages, except: :show do
        resource :page_type, only: :update
      end
      resources :collections, only: [] do
        resources :pages, controller: "collections/pages", except: [:show]
      end
      resources :redirects, only: :index
      resources :assets, only: [:index, :create]
    end

    # Admin API
    namespace :api do
      resources :sites do
        resources :pages, only: [:index, :show, :update]
        resources :redirects, except: [:new, :edit]
        resources :assets, only: [:index, :show, :create, :update, :destroy] do
          post :presign, on: :collection
        end
        resources :tags, only: [:index]
        resources :saved_search_fields, only: :index
      end
    end

    # Asset processing notifications
    post "asset_processing_notifications/:processor_name/:asset_id",
      format: "json",
      to: "asset_processing_notifications#create",
      as: "asset_processing_notifications"

    # Admin home
    root to: redirect("sites")
  end # Heracles::Admin::AdminHostConstraint
end
