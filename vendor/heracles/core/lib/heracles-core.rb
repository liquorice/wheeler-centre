require "active_job"
require "acts-as-taggable-on"
require "ancestry"
require "cloudinary"
require "contracts"
require "friendly_id"
require "interactor"
require "memoit"
require "nokogiri"
require "rails-observers"
require "ranked-model"
require "refile"
require "refile/s3"
require "transloadit-rails"
require "varnisher"
require "pg_search"

require "heracles/ext/ancestry_with_uuids"
require "heracles/ext/tag_with_slug"

require "heracles/configuration"
require "heracles/static_site_configuration"
require "heracles/site_configuration"
require "heracles/engine"
require "heracles/sites"
require "heracles/class_configurable"
require "heracles/fielded"
require "heracles/field_attributable"
require "heracles/field_attribute_sanitizable"
require "heracles/insertion_registerable"
require "heracles/content_field_rendering/pipeline"
require "heracles/content_field_rendering/filter"
require "heracles/content_field_rendering/assets_filter"
require "heracles/content_field_rendering/insertables_filter"
require "heracles/content_field_rendering/page_link_filter"
require "heracles/uploads/named_file_hasher"
require "heracles/uploads/s3_backend"
require "heracles/asset_processor"
require "heracles/cloudinary_asset_processor"
require "heracles/cloudinary_asset_presenter"
require "heracles/transloadit_asset_processor"
require "heracles/transloadit_asset_presenter"

module Heracles
  mattr_writer :user_class
  mattr_writer :site_administration_class

  class << self
    def user_class
      return if @@user_class.nil?
      raise "user_class must be a string" if !@@user_class.is_a?(String)

      begin
        Object.const_get(@@user_class)
      rescue
        @@user_class.constantize
      end
    end

    def site_administration_class
      return if @@site_administration_class.nil?
      raise "site_administration_class must be a string" if !@@site_administration_class.is_a?(String)

      begin
        Object.const_get(@@site_administration_class)
      rescue
        @@site_administration_class.constantize
      end
    end
  end
end
