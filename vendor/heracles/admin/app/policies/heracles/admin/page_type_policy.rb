module Heracles
  module Admin
    class PageTypePolicy < ApplicationPolicy
      class Scope < Struct.new(:user, :scope)
        def resolve
          if user.heracles_superadmin?
            scope
          else
            Array.wrap(scope).reject(&:hidden?)
          end
        end
      end
    end
  end
end
