module Heracles
  module Admin
    class PolicyParametersStrategy < DecentExposure::ActiveRecordStrategy
      def attributes
        @attributes ||= attributes_from_policy || attributes_from_method
      end

      def attributes_from_policy
        # Don't bother if there's no policy specified for the controller
        return unless controller.policy_class

        policy = controller.policy(scope)
        if policy.respond_to?(:permitted_attributes)
          # TODO: make the param_key configurable
          params.fetch(inflector.param_key, {}).permit(*policy.permitted_attributes)
        end
      end

      # Use the behaviour from StrongParametersStrategy for non-policied controllers
      def attributes_from_method
        controller.send(options[:attributes]) if options[:attributes]
      end

      def assign_attributes?
        singular? && !get? && !delete? && attributes.present?
      end

      def resource
        super.tap do |r|
          r.attributes = attributes if assign_attributes?
        end
      end
    end
  end
end

