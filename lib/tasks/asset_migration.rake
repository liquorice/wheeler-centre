require "progress_bar"

namespace :heracles do
  namespace :assets do
    desc "Convert legacy assets to a new format"
    task :new_convert_legacy => :environment do
      assets = Heracles::Asset.all.select{ |a| a.processed_assets.empty? }
      bar    = ProgressBar.new(assets.size)
      p "Convert #{ActionController::Base.helpers.pluralize(assets.size, "asset")}..."
      assets.each do |asset|
        processed_assets = asset.processed_assets
        if processed_assets.empty?

          # Create processed assets based on legacy_results

          versions = asset.legacy_results.inject({}) do |mem, version|
            k      = version[0].gsub("admin_", "heracles_admin_")
            v      = version[1]
            mem[k] = [{
              name:    v["name"],
              size:    v["size"],
              mime:    v["mime"],
              url:     v["url"],
              ssl_url: v["ssl_url"],
              meta:    v["meta"]
            }]
            mem
          end

          asset.processed_assets.create(
            processor: "transloadit",
            data: {
              assembly_id:      asset.legacy_assembly_id,
              assembly_url:     asset.legacy_assembly_url,
              assembly_message: asset.legacy_assembly_message,
              versions:         versions,
              raw_response:     asset.legacy_results
            }
          )

          # Update original asset values to match a new format

          legacy_meta = asset.legacy_file_meta
          orientation = if legacy_meta["width"].present? && legacy_meta["height"].present?
            if legacy_meta["width"] > legacy_meta["height"]
              "landscape"
            elsif legacy_meta["width"] < legacy_meta["height"]
              "portrait"
            else
              "square"
            end
          else
            nil
          end

          asset.update(
            processed_at:          DateTime.now,
            raw_width:             legacy_meta["width"],
            raw_height:            legacy_meta["height"],
            raw_orientation:       legacy_meta["orientation"],
            corrected_width:       legacy_meta["width"],
            corrected_height:      legacy_meta["height"],
            corrected_orientation: orientation,
            size:                  asset.legacy_file_size,
            content_type:          asset.legacy_file_mime,
            original_path:         URI(asset.legacy_results["original"]["ssl_url"]).path[1..-1]
          )

          bar.increment!
        end
      end
    end
  end
end
