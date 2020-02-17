module Heracles
  class SiteAdministration < ActiveRecord::Base
    self.table_name = "heracles_site_administrations"

    belongs_to :user
    belongs_to :site

    def self.sites_administerable_by(user)
      if !user
        Heracles::Site.none
      elsif user.heracles_superadmin?
        Heracles::Site.all
      else
        site_administrations = where(user_id: user)
        Heracles::Site.where(id: site_administrations.pluck(:site_id))
      end
    end
  end
end
