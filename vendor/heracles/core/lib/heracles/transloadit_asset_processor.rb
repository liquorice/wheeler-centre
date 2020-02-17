module Heracles
  module TransloaditAssetProcessor
    ADMIN_THUMBNAIL_VERSION = "heracles_admin_thumbnail".freeze
    ADMIN_PREVIEW_VERSION = "heracles_admin_preview".freeze

    extend self

    def processor_name
      :transloadit
    end

    def requires_initial_processing?
      true
    end

    def process_asset(asset)
      assembly_method = asset.site.configuration.use_notifications_for_asset_processing ? :with_notification_url : :and_poll
      response = send(:"submit_assembly_#{assembly_method}", asset)
      processed = (response["ok"] == "ASSEMBLY_COMPLETED")

      AssetProcessor::Response.new(processed, data_from_response(response))
    end

    def process_asset_notification(response)
      parsed_response = JSON.parse(response["transloadit"])
      AssetProcessor::Response.new(true, data_from_response(parsed_response))
    end

    private

    def submit_assembly_with_notification_url(asset)
      transloadit_client(asset).assembly({
        "steps" => assembly_steps(asset),
        "notify_url" => Heracles.configuration.asset_processing_notification_url(processor_name: processor_name, asset_id: asset.id)
      }).submit!
    end

    def submit_assembly_and_poll(asset)
      response = transloadit_client(asset).assembly({
        "steps" => assembly_steps(asset)
      }).submit!

      until response.finished?
        sleep 5
        response.reload!
      end

      raise AssetProcessingFailed if response.error?
      response
    end

    def transloadit_client(asset)
      Transloadit.new(
        key: asset.site.configuration.transloadit_auth_key,
        secret: asset.site.configuration.transloadit_auth_secret
      )
    end


    def submit_assembly(asset)

    end

    def assembly_steps(asset)
      site = asset.site
      extra_steps = site.configuration.transloadit_assembly_steps

      Hash.new.tap do |steps|
        steps["asset"] = {
          "robot" => "/s3/import",
          "key" => site.configuration.aws_s3_access_key_id,
          "secret" => site.configuration.aws_s3_secret_access_key,
          "bucket" => site.configuration.aws_s3_bucket,
          "path" => asset.original_path
        }

        steps[ADMIN_THUMBNAIL_VERSION] = {
          "robot" => "/image/resize",
          "use" => "asset",
          "width" => 400,
          "height" => 250,
          "resize_strategy" => "fit",
          "strip" => true
        }

        steps[ADMIN_PREVIEW_VERSION] = {
          "robot" => "/image/resize",
          "use" => "asset",
          "width" => 720,
          "height" => 720,
          "resize_strategy" => "fit",
          "zoom" => true,
          "strip" => "true"
        }

        steps.merge!(extra_steps)

        steps["store"] = {
          "robot" => "/s3/store",
          "use" => [ADMIN_THUMBNAIL_VERSION, ADMIN_PREVIEW_VERSION] + extra_steps.keys,
          "key" => site.configuration.aws_s3_access_key_id,
          "secret" => site.configuration.aws_s3_secret_access_key,
          "bucket" => site.configuration.aws_s3_bucket,
          "bucket_region" => site.configuration.aws_s3_region,
          "path" => "#{site.configuration.aws_s3_prefix}/processed/${unique_original_prefix}/${file.id}_${previous_step.name}.${file.ext}",
          "headers" => {
            "Cache-Control" => "public, max-age=31536000"
          }
        }
      end
    end

    def data_from_response(response)
      {
        assembly_id: response["assembly_id"],
        assembly_url: response["assembly_url"],
        assembly_message: response["assembly_message"],
        versions: Hash[response["results"].map { |version_name, version_results|
          [
            version_name,
            version_results.map { |result| # Results are arrays
              {
                name: result["name"],
                size: result["size"],
                mime: result["mime"],
                url: result["url"],
                ssl_url: result["ssl_url"],
                meta: result["meta"]
              }
            }
          ]
        }],
        raw_response: response
      }
    end
  end
end
