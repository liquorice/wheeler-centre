Heracles::Sites::<%= camel_case_site_name %>::Engine.routes.draw do
  post "*path/__preview" => "pages#show", preview: true
  get "*path" => "pages#show"
  root to: "pages#show"
end
