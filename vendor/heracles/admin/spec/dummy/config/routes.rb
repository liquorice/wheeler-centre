Rails.application.routes.draw do
  mount Heracles::Admin::Engine, at: "/admin"
end
