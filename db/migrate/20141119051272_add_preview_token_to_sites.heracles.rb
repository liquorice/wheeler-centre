# This migration comes from heracles (originally 20140411024312)
module Heracles
  class Site < ActiveRecord::Base
  end
end

class AddPreviewTokenToSites < ActiveRecord::Migration
  def change
    add_column :sites, :preview_token, :string

    Heracles::Site.find_each { |site| site.update_column :preview_token, SecureRandom.hex(20) }

    change_column :sites, :preview_token, :string, null: false
  end
end
