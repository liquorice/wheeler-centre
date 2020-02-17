json.pagination do
  json.current_page @assets.current_page
  json.total_pages @assets.total_pages
  json.next_page @assets.next_page
  json.prev_page @assets.prev_page
  json.first_page @assets.first_page?
  json.last_page @assets.last_page?
end
json.assets do
  json.array! @assets, partial: 'asset', as: :asset
end
json.more @more
