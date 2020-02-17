module Heracles
  module Admin
    module Api
      class AssetsController < Heracles::Admin::ApplicationController
        ### Behaviors

        respond_to :json

        before_filter :find_asset, only: [:update, :destroy]

        ### Actions

        def index
          @assets = paginate(find_assets)
          @more = @assets.count > 0
        end

        def show
          find_asset
        end

        def presign
          backend = Heracles::Uploads::S3Backend.backend_for_site(site)

          respond_to do |format|
            format.json { render json: backend.presign(presign_params).to_json }
          end
        end

        def create
          result = Heracles::CreateAsset.call(site: site, asset_params: asset_params)

          if result.success?
            @asset = result.asset
            respond_to :json
          else
            respond_to do |format|
              format.json { render json: {errors: result.errors.full_messages}, status: :unprocessable_entity }
            end
          end
        end

        def update
          @asset.update_attributes(asset_params)
          respond_with @asset
        end

        def destroy
          Heracles::DeleteAsset.call(asset: @asset)
          respond_with @asset
        end

        private

        def find_asset
          @asset = site.assets.find(params[:id])
        end

        def find_assets
          params[:q].present? ? search_assets : query_assets
        end

        def search_assets
          type_scope     = %w(images videos audio documents).include?(params[:type]) ? params[:type] : "all"
          search_scope   = %w(file_name title tags).include?(params[:fields]) ? params[:fields] : "file_name"
          search_results = Heracles::Asset.send(type_scope).where("site_id = ?", site.id).send("search_by_#{search_scope}", params[:q])

          paginate search_results, page: params[:page].presence || 1, per_page: params[:per_page].presence || 40
        end

        def query_assets
          per_page = params[:per_page].presence || 40

          if params[:asset_ids].present?
            asset_ids = params[:asset_ids].split(",")
            assets = site.assets.where(id: asset_ids).reorder(assets_order_sql(asset_ids))
            per_page = asset_ids.length
          else
            assets = site.assets.reorder("created_at DESC")
            assets = case params[:type]
              when "image" then assets.images
              when "video" then assets.videos
              when "audio" then assets.audio
              when "document" then assets.documents
              else assets
            end
          end

          assets.page(params[:page]).per(per_page)
        end

        def presign_params
          params.permit(
            :content_type,
            :file_name
          )
        end

        def assets_order_sql(asset_ids)
          sql = "CASE assets.id "
          asset_ids.each_with_index do |id, position|
            sql += "WHEN '#{id}' THEN #{position} "
          end
          sql += "END"
          sql
        end

        def asset_params
          params.permit(
            :attribution,
            :content_type,
            :corrected_height,
            :corrected_orientation,
            :corrected_width,
            :description,
            :file_name,
            :original_path,
            :raw_height,
            :raw_orientation,
            :raw_width,
            :size,
            :title,
            tag_list: []
          )
        end
      end
    end
  end
end
