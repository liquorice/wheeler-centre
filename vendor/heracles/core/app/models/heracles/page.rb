module Heracles
  class Page < ActiveRecord::Base
    ### Behaviors

    # Heracles
    include ClassConfigurable
    include Fielded
    include InsertionRegisterable
    include RankedModel
    include PgSearch

    acts_as_taggable_on :tags

    has_ancestry cache_depth: true

    ranks :page_order, with_same: [:site_id, :ancestry], class_name: "Heracles::Page"

    pg_search_scope :search_by_title_and_tag,
      against: :title,
      associated_against: {
        tags: [:name]
      },
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

    ### Callbacks

    before_validation :set_updated_url
    before_save :set_updated_insertion_key
    after_save :update_descendant_urls
    after_save :update_insertions
    after_save :touch
    after_save :touch_inserted
    after_commit :touch_hierarchy
    before_destroy :destroy_insertions

    ### Associations

    belongs_to :site, class_name: "Heracles::Site"
    belongs_to :collection, class_name: "Heracles::Collection"

    has_many :insertions, class_name: "Heracles::Insertion"
    has_many :inserteds, primary_key: :insertion_key, foreign_key: :inserted_key, class_name: "Heracles::Insertion"

    ### Validations

    validates! :site, presence: true
    validates! :type, presence: true
    validates :title, presence: true
    validates :slug, presence: true
    validates :url, presence: true, if: "slug.present?"
    validates :url, uniqueness: {scope: :site_id, if: "slug.present?", message: "requires a unique slug for this level in the page tree"}

    ### Scopes

    def self.first
      order("created_at ASC").first
    end

    def self.last
      order("created_at DESC").first
    end

    scope :published, -> { where(published: true) }

    scope :hidden, -> { where(hidden: true) }

    scope :visible, -> { where(hidden: false) }

    scope :of_type, ->(type) { where("type LIKE ?", "%::#{type.to_s.camelize}") }

    scope :uncontained, -> { where(collection_id: nil) }

    scope :in_order, -> { rank :page_order }

    ### Factories

    def self.new_for_site_and_page_type(site, page_type)
      raise Site::ModuleMissing, "site has no module for its page classes" unless site.module

      page_class = "#{site.module}::#{page_type.to_s.camelize}".constantize
      raise NameError, "No #{page_type.to_s.camelize} in #{site.module} module" if page_class.parent != site.module

      page_class.new do |page|
        page.site = site
      end
    end

    ### Finders

    # Public: Find a field located on a page anywhere within this page's site.
    #
    # path  - The field lookup path: the page URL and field name, separated by
    #         a "#" (e.g. "/some/page#field_name").
    #
    # Examples
    #
    #   field_at("/some/page#field_name")
    #   # => #<Heracles::Fielded::ContentField>
    #
    # This method exists to allow a page's fields configuration to define
    # fallbacks for its fields. It delegates to the same-named one on
    # `Heracles::Site`, with on exception: if the field being searched for is
    # on the same page as this one, then nothing is returned. This ensures we
    # don't enter an infinite loop if the fallback field is on a page with the
    # same page type as the current one.
    #
    # Returns the Field, if found, or nil.
    def field_at(path)
      return nil if path.to_s.sub(/^\//, "").split("#").first == url

      site.field_at(path)
    end

    ### Commands

    def child_collection_with_slug(slug)
      collection = children.find_by(slug: slug)
      collection if collection.collection?
    end

    def to_page_type!(page_type)
      return self if page_type == self.page_type

      raise Site::ModuleMissing, "site has no module for its page classes" unless site.module

      page_class = "#{site.module}::#{page_type.camelize}".constantize
      raise NameError, "No #{page_type.camelize} in #{site.module} module" if page_class.parent != site.module

      # We can't use `#becomes!` here and save the resulting record, because
      # the type scoping prevents it from being found. Instead, just update
      # and save the column directly (which avoids validation, since the new
      # page type may not be valid), and then return the transformed page.
      update_column(:type, page_class)
      becomes(page_class)
    end

    def update_insertions
      destroy_insertions
      fields.to_a.each(&:register_insertions)
    end

    # Public: Update the `url` attribute.
    #
    # Builds and assigns the `url` based on the parent page's `url`, followed by
    # the page's `slug`. Does not save the record.
    def set_updated_url
      self.url = [parent.try(:url), slug].compact.join("/")
    end

    def set_updated_insertion_key
      self.insertion_key = insertion_key
    end

    def to_summary_hash
      {title: title, created_at: created_at.to_s(:admin_date)}
    end

    ### Default children config

    def self.default_children_config
      Array.wrap(config[:default_children])
    end
    delegate :default_children_config, to: :class

    ### Class accessors

    def self.site_namespace
      self.parent
    end

    def self.site_slug
      underscored_site_slug.gsub("_", "-")
    end

    def self.underscored_site_slug
      site_namespace.name.underscore.split("/").last
    end

    # Public: Return a short page type string.
    #
    # Examples
    #
    #   page_type
    #   # => "content_page"
    #
    # Modifies the STI `type` attribute so that it can be used in contexts that
    # need a simple string, such as finding a template to use for page
    # rendering.
    def self.page_type
      name.demodulize.underscore
    end
    delegate :page_type, to: :class

    ### Instance accessors

    def allowed_child_page_classes
      Array.wrap(site.try(:page_classes))
    end

    def allowed_alternative_page_classes
      parent.try(:allowed_child_page_classes) || Array.wrap(site.try(:page_classes))
    end

    def absolute_url
      url ? "/" + url : nil
    end

    ### Predicates

    def self.hidden?
      false
    end

    def self.page?
      true
    end
    delegate :page?, to: :class

    def self.collection?
      false
    end
    delegate :collection?, to: :class

    def child_pages_allowed?
      !home_page?
    end

    def sortable?
      !home_page?
    end

    def deleteable?
      !home_page?
    end

    def visible?
      !hidden?
    end

    ### Cache helpers

    def hierarchy_cache_key
      key = ancestors.select(:id, :updated_at, :type, :ancestry, :site_id).map(&:cache_key) << cache_key
      Digest::MD5.hexdigest key.join("")
    end

    private

    ### Private helpers

    def home_page?
      url.to_s == "home"
    end

    ### Private callback methods

    def update_descendant_urls
      return unless url_changed?

      # FIXME: this is too slow when changing a URL at the top of a big sub-tree.
      descendants.each do |page|
        page.set_updated_url
        page.save!
      end
    end

    def touch_inserted
      Insertion.for_inserted(self).each(&:touch)
    end

    def destroy_insertions
      Insertion.on_page(self).delete_all
    end

    def touch_hierarchy
      if is_root?
        site.pages.where(id: sibling_ids).update_all(updated_at: Time.current)
      else
        ancestors.update_all(updated_at: Time.current)
      end
    end
  end
end
