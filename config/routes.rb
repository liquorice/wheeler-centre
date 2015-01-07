Rails.application.routes.draw do
  # Heracles admin
  mount Heracles::Admin::Engine, at: "/admin"

  # Admin
  resource :admin, only: [:show]

  # Heracles public pages.
  post "*path/__preview" => "pages#show", preview: true
  get "*path" => "pages#show"
  root to: "pages#show"
end
