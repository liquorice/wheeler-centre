module Heracles
  module ClassConfigurable
    extend ActiveSupport::Concern

    included do
      delegate :config, to: :class
    end

    module ClassMethods
      def config
        {}
      end
    end
  end
end
