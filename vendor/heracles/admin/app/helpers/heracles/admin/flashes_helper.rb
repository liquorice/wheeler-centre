module Heracles
  module Admin
    module FlashesHelper
      def flashes
        safe_join(flash.keys.map do |type|
          content_tag :aside, class: ["flash", "flash--#{type}"] do
            content_tag :div, flash[type], class: "wrapper"
          end
        end)
      end

      BOOTSTRAP_FLASH = Hash.new { |hash, key| key }.merge!(notice: :success, alert: :danger).freeze

      def bootstrap_flashes
        safe_join(flash.keys.map { |type| bootstrap_flash(type) })
      end

      def bootstrap_flash type
        content_tag :div, class: ["alert", "alert--#{BOOTSTRAP_FLASH[type]}"] do
          flash[type]
        end
      end
    end
  end
end
