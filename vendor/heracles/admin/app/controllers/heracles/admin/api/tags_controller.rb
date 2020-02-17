module Heracles
  module Admin
    module Api
      class TagsController < Heracles::Admin::ApplicationController
        respond_to :json

        def index
          @tags = paginate(find_tags)
        end

        private

        def find_tags
          params[:q].present? ? search_tags : query_tags
        end

        def query_tags
          ActsAsTaggableOn::Tag.order("taggings_count DESC").page(params[:page]).per(20)
        end

        def search_tags
          ActsAsTaggableOn::Tag.where("name ILIKE ?", "#{params[:q]}%").order("taggings_count DESC").page(params[:page]).per(20)
        end
      end
    end
  end
end
