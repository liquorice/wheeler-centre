require "progress_bar"

namespace :heracles do
  namespace :pages do
    desc "Rebuild all insertions"
    task rebuild_insertions: :environment do
      Heracles::Insertion.delete_all

      bar = ProgressBar.new(Heracles::Page.count)

      Heracles::Page.find_each do |page|
        page.update_insertions
        bar.increment!
      end
    end
  end

  namespace :assets do
    desc "Convert asset field names to a new format"
    task :update_fields => :environment do
      pages = Heracles::Page.all
      bar   = ProgressBar.new(pages.size)

      p "Convert asset fields for #{ActionController::Base.helpers.pluralize(pages.size, "page")}..."
      pages.each do |page|

        fields_data = page.fields_data.inject({}) do |memo, field|
          if field[1]["field_type"] == "asset"
            asset = field[1]

            asset["field_type"] = "assets"
            asset["asset_ids"]  = field[1]["asset_id"].present? ? [field[1]["asset_id"]] : []
            asset.tap { |key| key.delete("asset_id") }

            memo[field[0]] = asset
          else
            memo[field[0]] = field[1]
          end
          memo
        end

        page.update(fields_data: fields_data)

        bar.increment!
      end
    end

    desc "Convert legacy assets to a new format"
    task :convert_legacy => :environment do
      assets = Heracles::Asset.all
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
            original_path:         URI(asset.legacy_results["original"]["url"]).path[1..-1]
          )

          bar.increment!
        end
      end
    end
  end
end
