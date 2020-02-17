json.(
  asset,
  :id,
  :file_name,
  :content_type,
  :raw_width,
  :raw_height,
  :raw_orientation,
  :corrected_width,
  :corrected_height,
  :corrected_orientation,
  :original_path,
  :original_url,
  :size,
  :title,
  :description,
  :attribution,
  :tag_list,
)

json.processed asset.processed?

json.(asset, :created_at)

json.thumbnail_url asset_admin_thumbnail_url(asset)
json.preview_url asset_admin_preview_url(asset)
