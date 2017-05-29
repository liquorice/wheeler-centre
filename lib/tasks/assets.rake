namespace :assets do
  desc "Build the public assets with make/duo"
  task :build do
    system 'npm run build-production'
  end

  desc "Reprocess incomplete image assets with Transloadit"
  task reprocess_incomplete_images: :environment do
    Heracles::Asset.
    images.
    reject {|a|
      a.processed_assets.first.versions.key?("original") || a.processed_assets.first.versions.key?("content_small")
    }.each do |asset|

      Rails.logger.info "reprocess_images — processing asset.id: #{asset.id} ..."

      Heracles::ProcessAssetJob.perform_now_or_later_as_required(asset)
      loop do
        sleep(1)
        break if asset.processed_assets.first.versions.key?("original") && a.processed_assets.first.versions.key?("content_small")
      end
    end
  end

  desc "Reprocess incomplete audio assets with Transloadit"
  task reprocess_incomplete_audio: :environment do
    Heracles::Asset.
      audio.
      reject {|a|
        a.processed_assets.first.versions.key?("original") || a.processed_assets.first.versions.key?("audio_mp3")
      }.each do |asset|

      Rails.logger.info "reprocess_images — processing asset.id: #{asset.id} ..."

      Heracles::ProcessAssetJob.perform_now_or_later_as_required(asset)
      loop do
        sleep(1)
        break if asset.processed_assets.first.versions.key?("original") && a.processed_assets.first.versions.key?("audio_mp3")
      end
    end
  end

  desc "Reprocess incomplete audio assets with Transloadit"
  task reprocess_incomplete_video: :environment do
    Heracles::Asset.
      videos.
      reject {|a|
        a.processed_assets.first.versions.key?("original") || a.processed_assets.first.versions.key?("audio_mp3")
      }.each do |asset|

      Rails.logger.info "reprocess_images — processing asset.id: #{asset.id} ..."

      Heracles::ProcessAssetJob.perform_now_or_later_as_required(asset)
      loop do
        sleep(1)
        break if asset.processed_assets.first.versions.key?("original") && a.processed_assets.first.versions.key?("audio_mp3")
      end
    end
  end
end

Rake::Task["assets:precompile"].enhance ["assets:clobber"] do
  Rake::Task["assets:build"].invoke
end
