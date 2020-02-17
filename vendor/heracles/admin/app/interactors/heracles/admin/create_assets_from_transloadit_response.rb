module Heracles
  module Admin
    class CreateAssetsFromTransloaditResponse
      include Interactor

      def call
        context.fail!(message: "No uploads provided") and return unless uploads_present?

        context.assets = Heracles::Asset.build_from_transloadit_response(context.transloadit, site: context.site)

        begin
          Heracles::Asset.transaction do
            context.assets.each(&:save!)
          end
        rescue ActiveRecord::RecordInvalid
          context.fail!
        end
      end

      private

      def uploads_present?
        context[:transloadit].try(:[], :uploads).present?
      end
    end
  end
end
