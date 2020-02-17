module Heracles
  module Admin
    class ApplicationPolicy
      attr_reader :user, :record

      def initialize(user, record)
        @user = user
        @record = record
      end

      def permitted_attributes
        []
      end

      def index?
        false
      end

      def show?
        scope.where(:id => record.id).exists?
      end

      def create?
        false
      end

      def new?
        create?
      end

      def update?
        false
      end

      def edit?
        update?
      end

      def destroy?
        false
      end

      class Scope < Struct.new(:user, :scope)
        def resolve
          scope
        end
      end
    end
  end
end
