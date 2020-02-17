module Heracles
  class Redirect < ActiveRecord::Base
    ### Behaviors

    include RankedModel

    ranks :redirect_order, with_same: :site_id

    ### ActiveModel behavior

    def self.model_name
      ActiveModel::Name.new(self, _namespace=nil, "Redirect")
    end

    ### Associations

    belongs_to :site, class_name: "Heracles::Site"

    ### Validations

    validates! :site, presence: true
    validates :source_url, format: {with: /\A\/.*/}
    validates :target_url, format: {with: /\A(https?:\/\/|\/).*/}
  end
end
