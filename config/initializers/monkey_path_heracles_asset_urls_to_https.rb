# Heracles::Asset.class_eval do
#   # Copy the original implementation for asset version shortcut access from
#   # Heracles::Asset and add a step to replace S3 URLs with the Cloudfront
#   # domain (if present).
#   #
#   # n.b. this will only work for the shortcut access to version attributes.
#   # Accessing a URL via `asset["version_name"]["url"]` will always return the
#   # original data from Transloadit (i.e. the non-CDN S3 URL).
#   def method_missing(symbol, *args)
#     return super if versions.blank?

#     version = symbol.to_s.match(/^(#{versions.join("|")})_url$/).try(:captures).first

#     return super unless version

#     results[version]["url"].tap do |data|
#       data.gsub!(%r{^https?:\/\/}, "https://")
#     end
#   end
# end
