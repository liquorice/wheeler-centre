module Heracles
  module Sites
    module WheelerCentre
      class Person < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :display_name, type: :text},
              {name: :first_name, type: :text},
              {name: :last_name, type: :text},
              {name: :portrait, type: :asset, asset_file_type: :image},
              {name: :intro, type: :content},
              {name: :biography, type: :content},
              {name: :url, type: :text},
              {name: :reviews, type: :content},
              {name: :external_links, type: :content},
              {name: :is_staff_member, type: :boolean, defaults: {value: false}, question_text: "Is a Wheeler Centre staff member?"},
              {name: :staff_bio, type: :content, label: "Staff biography", display_if: 'is_staff_member.value'},
              {name: :position_title, type: :text, display_if: 'is_staff_member.value'},
              {name: :user_id, type: :integer, label: "User id"},
            ]
          }
        end

        searchable do
          text :display_name do
            fields[:display_name].value
          end

          text :first_name do
            fields[:first_name].value
          end

          text :last_name do
            fields[:last_name].value
          end

          text :intro do
            fields[:intro].value
          end

          text :biography do
            fields[:biography].value
          end

          text :url do
            fields[:url].value
          end

          text :reviews do
            fields[:reviews].value
          end

          text :external_links do
            fields[:external_links].value
          end

        end
      end
    end
  end
end
