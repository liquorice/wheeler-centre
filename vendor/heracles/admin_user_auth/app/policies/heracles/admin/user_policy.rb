module Heracles
  module Admin
    class UserPolicy < ApplicationPolicy
      def index?
        user.heracles_superadmin?
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
        if user.heracles_superadmin?
          [:name, :email, :password, :password_confirmation, :superadmin, site_ids: []]
        else
          []
        end
      end

      class Scope < Struct.new(:user, :scope)
        def resolve
          if user.heracles_superadmin?
            scope
          else
            scope.none
          end
        end
      end
    end
  end
end
