json.redirects do
  json.array! redirects, partial: "redirect", as: :redirect
end
