Heracles::Admin::Engine.routes.draw do
  scope constraints: Heracles::Admin::AdminHostConstraint do
    # User authentication
    devise_for :users,
      class_name: "Heracles::User",
      module: :devise,
      controllers: {
        sessions: "heracles/admin_user_auth/sessions",
        passwords: "heracles/admin_user_auth/passwords",
      }

    # User management
    resources :users, except: :show
  end
end
