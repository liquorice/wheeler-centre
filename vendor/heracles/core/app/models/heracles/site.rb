# Sites house content at specified hostnames.
#
# All public-facing CMS content should relate to a site.
#
# Each site has its own Rails engine for supplying view, assets and other logic.
module Heracles
  class Site < ActiveRecord::Base
    ### Exceptions

    class ModuleMissing < StandardError; end

    ### ActiveModel behavior

    def self.model_name
      ActiveModel::Name.new(self, _namespace=nil, "Site")
    end

    ### Callbacks

    before_create :set_preview_token

    ### Associations

    has_many :pages, -> { rank :page_order }, dependent: :destroy
    has_many :redirects, -> { rank :redirect_order }, dependent: :destroy
    has_many :assets, -> { order("created_at ASC") }, dependent: :destroy

    ### Validations

    validates :title, presence: true
    validates :slug, presence: true, uniqueness: true, format: {with: /\A[a-zA-Z][a-z0-9-]+\z/, message: "must start with a letter and then be simple letters, numbers and dashes"}
    validates :origin_hostnames, :edge_hostnames, array: {format: {with: /\A(localhost|[\w-]+\.[\w.-]+)(:\d+)?\z/, message: "must be a simple host name"}}

    ### Scopes

    def self.first
      order("created_at ASC").first
    end

    def self.last
      order("created_at DESC").first
    end

    ### Finders

    def self.servable
      where(published: true).to_a.select(&:engine)
    end

    def self.find_by_hostname(name)
      find_by("? = ANY(origin_hostnames) OR ? = ANY(edge_hostnames)", name, name)
    end

    def self.find_by_origin_hostname(name)
      find_by("? = ANY(origin_hostnames)", name)
    end

    def self.find_by_edge_hostname(name)
      find_by("? = ANY(edge_hostnames)", name)
    end

    def self.find_by_hostname!(name)
      find_by_hostname(name) || raise(ActiveRecord::RecordNotFound)
    end

    ### Child finders

    # Public: Find a field located on a page anywhere within the site.
    #
    # path  - The field lookup path: the page URL and field name, separated by
    #         a "#" (e.g. "/some/page#field_name").
    #
    # Examples
    #
    #   field_at("/some/page#field_name")
    #   # => #<Heracles::Fielded::ContentField>
    #
    # Returns the Field, if found, or nil.
    def field_at(path)
      url, field_name = path.to_s.sub(/^\//, "").split("#")
      page = pages.find_by_url(url)

      page.fields[field_name] if page
    end

    ### Accessors

    def underscored_slug
      slug.gsub("-", "_")
    end

    def primary_hostname
      primary_edge_hostname.presence || primary_origin_hostname
    end

    def primary_origin_hostname
      origin_hostnames.first
    end

    def primary_edge_hostname
      edge_hostnames.first
    end

    def space_delimited_origin_hostnames
      origin_hostnames.join(" ")
    end

    def space_delimited_origin_hostnames=(value)
      self.origin_hostnames = value.to_s.split(/\s+/)
    end

    def space_delimited_edge_hostnames
      edge_hostnames.join(" ")
    end

    def space_delimited_edge_hostnames=(value)
      self.edge_hostnames = value.to_s.split(/\s+/)
    end

    def all_hostnames
      edge_hostnames + origin_hostnames
    end

    def page_classes
      return [] if self.module.nil?

      Heracles::Page.descendants.
        select  { |klass| klass.parents.include?(self.module) }.
        sort_by { |klass| klass.name }
    end

    def module
      begin
        Heracles::Sites.const_get(underscored_slug.camelize.to_sym)
      rescue NameError
        nil
      end
    end

    def engine
      begin
        return nil unless self.module
        self.module::Engine
      rescue NameError
        nil
      end
    end

    def configuration
      self.module::SiteConfiguration.new(self)
    end

    def engine_path
      "heracles/sites/#{underscored_slug}"
    end

    ### Predicates

    def has_edge_delivery?
      edge_hostnames.present?
    end

    ### Commands

    def to_param
      slug
    end

    private

    ### Private callbacks

    def set_preview_token
      self.preview_token = SecureRandom.hex(20)
    end
  end
end
