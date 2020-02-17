module Heracles
  module Admin
    class SitePolicy < ApplicationPolicy
      def index?
        true
      end

      def create?
        user.heracles_superadmin?
      end

      def update?
        user.heracles_superadmin?
      end

      def destroy?
        user.heracles_superadmin?
      end

      def permitted_attributes
        %i(published slug space_delimited_origin_hostnames space_delimited_edge_hostnames title transloadit_params)
      end

      class Scope < Struct.new(:user, :scope)
        def resolve
          Heracles.site_administration_class.sites_administerable_by(user)
        end
      end
    end
  end
end
