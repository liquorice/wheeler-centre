require "uri"
require "open-uri"

module Heracles
  class Asset < ActiveRecord::Base
    ### Behaviors

    include Contracts
    include InsertionRegisterable
    include PgSearch

    acts_as_taggable_on :tags

    ## Search scopes

    pg_search_scope :search_by_file_name,
      against: :file_name,
      using: {
        tsearch: {prefix: true},
        trigram: {threshold: 0.1}
      }

    pg_search_scope :search_by_title,
      against: :title,
      using: {
        tsearch: {prefix: true},
        trigram: {}
      }

    pg_search_scope :search_by_tags,
      associated_against: {
        tags: [:name]
      },
      using: {
        tsearch: {prefix: true},
        trigram: {}
      }

    ### ActiveModel behavior

    def self.model_name
      ActiveModel::Name.new(self, _namespace=nil, "Asset")
    end

    ### Assocations

    belongs_to :site
    has_many :processed_assets

    ### Validations

    validates! \
      :content_type,
      :file_name,
      :original_path,
      presence: true

    ### Scopes

    def self.first
      order("created_at ASC").first
    end

    def self.last
      order("created_at DESC").first
    end

    scope :processed,   -> { where("processed_at IS NOT NULL") }
    scope :unprocessed, -> { where(processed_at: nil) }

    scope :images, -> { where("content_type LIKE ?", "image%") }
    scope :videos, -> { where("content_type LIKE ?", "video%") }
    scope :audio,  -> { where("content_type LIKE ? OR content_type LIKE ?", "audio%", "video%") }
    scope :documents, -> { where("content_type NOT LIKE ? AND content_type NOT LIKE ? AND content_type NOT LIKE ?", "image%", "audio%", "video%") }

    def self.by_created(direction="DESC")
      direction = (direction == "ASC" ? "ASC" : "DESC")
      order("created_at #{direction}")
    end

    ### Attributes

    def original_url
      protocol = secure? ? "https" : "http"
      "#{protocol}://#{site.configuration.aws_s3_bucket}.s3.amazonaws.com/#{original_path}"
    end
    alias_method :url, :original_url

    def aspect_ratio
      return nil unless corrected_width.present? && corrected_height.present?

      corrected_width.to_f / corrected_height.to_f
    end

    def processed_asset
      processed_assets.first
    end

    def versions
      processed_asset.versions
    end

    def method_missing(method_id, *arguments, &block)
      method_name = method_id.to_s
      version     = method_name.gsub("_url", "")
      if method_name.split("_").last == "url"
        if secure?
          processed_asset.versions[version][0]["ssl_url"]
        else
          processed_asset.versions[version][0]["url"]
        end
      else
        super
      end
    end

    ### Predicates

    def processed?
      processed_at?
    end

    def secure?
      site.configuration.use_ssl_for_asset_urls
    end

    # TODO: change to work off content_type

    # def image?
    #   file_types.include?("image")
    # end

    # def video?
    #   file_types.include?("video")
    # end

    # def document?
    #   file_types.blank?
    # end
  end
end
