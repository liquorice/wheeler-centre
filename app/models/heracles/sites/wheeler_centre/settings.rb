module Heracles
  module Sites
    module WheelerCentre
      class Settings < ::Heracles::Page
        def self.config
          {
            fields: [
              # Subscribe popup
              {name: :subscript_popup_info, type: :info, text: "<hr/>"},
              {name: :subscribe_popup_intro, type: :content, with_buttons: %i(h2 h3 bold italic link), with_insertables: %i(image)},
              {name: :subscribe_popup_image, type: :asset, asset_file_type: :image},
              {name: :subscribe_popup_enabled, label: "Enable subscribe popup", type: :boolean, defaults: {value: true}, question_text: "Show the subscribe popup to new vistors?"},
            ]
          }
        end
      end
    end
  end
end
