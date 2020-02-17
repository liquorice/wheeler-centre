Rails.application.routes.draw do
  mount Heracles::PublicSiteManager::Engine, at: "/"
end
