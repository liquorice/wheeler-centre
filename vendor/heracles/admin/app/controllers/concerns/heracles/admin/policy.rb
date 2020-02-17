module Heracles
  module Admin
    module Policy
      class NotAuthorizedError < StandardError
        attr_accessor :action, :record, :policy
      end

      extend ActiveSupport::Concern

      included do
        class_attribute :policy_class

        helper_method :policy
        helper_method :policy_scope

      end

      def policy_class
        self.class.policy_class
      end

      def authorize(record, action=nil)
        action ||= params[:action].to_s + "?"
        policy = policy(record)

        unless policy.public_send(action)
          error = NotAuthorizedError.new("not allowed to #{action.sub('?', '')} this #{record}")
          error.action, error.record, error.policy = action, record, policy
          raise error
        end
      end

      def policy(record)
        policy_class.new(policy_user, record)
      end

      def policy_scope(scope)
        policy_class::Scope.new(policy_user, scope).resolve
      end

      def policy_user
        heracles_admin_current_user
      end
    end
  end
end
