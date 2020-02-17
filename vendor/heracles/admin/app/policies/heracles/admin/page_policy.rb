module Heracles
  module Admin
    class PagePolicy < ApplicationPolicy
      def index?
        true
      end

      def create?
        true
      end

      def update?
        true
      end

      def destroy?
        !record.locked?
      end

      def change_template?
        user.heracles_superadmin?
      end

      def change_page_type?
        !record.locked?
      end

      def permitted_attributes
        if user.heracles_superadmin?
          base_attributes + superadmin_attributes
        else
          base_attributes
        end
      end

      class Scope < Struct.new(:user, :scope)
        def resolve
          scope
        end
      end

      private

      def base_attributes
        [:form_fields_json, :hidden, :published, :slug, :title, :tag_list]
      end

      def superadmin_attributes
        [:template]
      end
    end
  end
end
