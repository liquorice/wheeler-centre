module Heracles
  module Sites
    module WheelerCentre
      class Settings < ::Heracles::Page
        def self.config
          {
            fields: [
              # Subscribe popup
              {name: :subscribe_popup_info, type: :info, text: "<h2>Subscribe popup</h2><hr/>"},
              {name: :subscribe_popup_enabled, label: "Enable subscribe popup", type: :boolean, defaults: {value: true}, question_text: "Show the subscribe popup to new vistors?", editor_columns: 6},
              {name: :subscribe_popup_force, label: "Force subscribe popup", type: :boolean, question_text: "Always show the subscribe popup? (even to existing visitors)", editor_columns: 6},
              {name: :subscribe_popup_intro, type: :content, with_buttons: %i(h2 h3 bold italic link), with_insertables: %i(image)},
              {name: :subscribe_popup_image, type: :assets, label: "Subscribe background image", asset_file_type: :image},
              {name: :subscribe_popup_campaign, label: "Subscribe popup campaign code", type: :text, editor_type: "code", hint: "Setting a new code like 'jaipur-2015' here will reset the counter and show it to everyone again."},
              # Campaign banner
              {name: :campaign_banner_info, type: :info, text: "<h2>Campaign banner</h2><hr/>"},
              {name: :campaign_banner_enabled, label: "Enable campaign banner", type: :boolean, defaults: {value: true}, question_text: "Show the campaign banner to new vistors?", editor_columns: 6},
              {name: :campaign_banner_force, label: "Force campaign banner", type: :boolean, question_text: "Always show the campaign banner? (even to existing visitors)", editor_columns: 6},
              {name: :campaign_banner_background_image, type: :assets, label: "Campaign background image", asset_file_type: :image},
              {name: :campaign_banner_content, type: :content, with_buttons: %i(h2 h3 bold italic link), with_insertables: %i(image)},
              {name: :campaign_banner_link, type: :text, editor_type: "code"},
              {name: :campaign_banner_code, label: "Campaign code", type: :text, editor_type: "code", hint: "Setting a new code like 'jaipur-2015' here will reset the counter and show it to everyone again."},
              # Events
              {name: :events_info, type: :info, text: "<h2>Events</h2><hr/>"},
              {name: :events_cancelled_message, type: :content, disable_insertables: true}
            ]
          }
        end
      end
    end
  end
end
