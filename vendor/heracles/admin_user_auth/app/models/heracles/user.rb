module Heracles
  class User < ActiveRecord::Base
    self.table_name = "heracles_users"

    ### Behaviors

    devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

    ### Associations

    has_many :site_administrations, dependent: :destroy
    has_many :sites, -> { order("slug ASC") }, through: :site_administrations

    ### Validations

    validates :name, presence: true

    ### Scopes

    def self.first
      order("created_at ASC").first
    end

    def self.last
      order("created_at DESC").first
    end

    ### Pluggable Heracles user support

    def heracles_admin_name
      name
    end

    def heracles_admin?
      true
    end

    def heracles_superadmin?
      superadmin?
    end

    ### Commands

    def to_s
      name
    end
  end
end
