json.tags do
  json.array! @tags, partial: "tag", as: :tag
end
