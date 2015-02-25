module Heracles
  module Sites
    module WheelerCentre
      class Settings < ::Heracles::Page
        def self.config
          {
            fields: [
              # Subscribe popup
              {name: :subscript_popup_info, type: :info, text: "<hr/>"},
              {name: :subscribe_popup_campaign, label: "Subscribe popup campaign code", type: :text, editor_type: "code", hint: "Setting a new code like 'jaipur-2015' here will reset the subscribe popup counter and show it to everyone again."},
              {name: :subscribe_popup_intro, type: :content, with_buttons: %i(h2 h3 bold italic link), with_insertables: %i(image)},
              {name: :subscribe_popup_image, type: :asset, label: "Subscribe background image", asset_file_type: :image},
              {name: :subscribe_popup_enabled, label: "Enable subscribe popup", type: :boolean, defaults: {value: true}, question_text: "Show the subscribe popup to new vistors?", editor_columns: 6},
              {name: :subscribe_popup_force, label: "Force subscribe popup", type: :boolean, question_text: "Always show the subscribe popup? (even to existing visitors)", editor_columns: 6},
            ]
          }
        end
      end
    end
  end
end
