module Heracles
  module Admin
    module Api
      class SavedSearchFieldsController < ApplicationController
        respond_to :json

        MATCH_TYPES = %i(equal_to less_than greater_than less_than_or_equal_to greater_than_or_equal_to between any_of all_of)
        STATEMENTS  = MATCH_TYPES.map { |match_type| {name: match_type.to_s.humanize.downcase, type: match_type} }

        def index
          respond_with do |format|
            format.json { render json: {
              page_types: site.page_classes.map { |page_class|
                { name: page_class.page_type.humanize,
                  type: page_class.page_type
                }
              },
              searchable_fields: extract_searchable_fields.map { |field|
                { name: field[:name].to_s.humanize,
                  type: field[:name]
                }
              },
              fields_matching: extract_searchable_fields.inject({}) { |memo, field|
                memo[field[:name]] = matchings_by_fieldtype(field[:fieldtype])
                memo
              },
              themes: extract_theme_names
            }}
          end
        end

        private

        def extract_searchable_fields
          odd_fields = %i(tags hidden locked collection_id parent_id site_id)

          (column_based_fields + heracles_based_fields).flatten.uniq.reject { |field|
            odd_fields.include?(field[:name])
          }.sort_by { |field|
            field[:name].to_s
          }
        end

        def column_based_fields
          site.page_classes.map { |page_class|
            page_class.columns_hash.map { |name, data|
              { name: name, fieldtype: data.type }
            }
          }
        end

        def heracles_based_fields
          site.page_classes.map { |page_class|
            page_class.fields_config.map { |field|
              { name: field[:name], fieldtype: field[:type] }
            }
          }
        end

        def extract_theme_names
          ApplicationController.view_paths.map(&:to_s).inject([]) { |memo, directory|
            full_path = "#{directory}/saved_searches/#{site.engine_path}/"
            memo += Dir.glob("#{full_path}*").select { |path| File.directory?(path) }.map { |path| path.gsub(full_path, "") }
            memo
          }
        end

        def matchings_by_fieldtype(klass)
          case klass
            # @TODO: set proper matchers for each available field type
            when "string"  then pick_matching(:equal_to, :any_of, :all_of)
            when "integer" then pick_matching(:equal_to, :less_than, :greater_than, :less_than_or_equal_to, :greater_than_or_equal_to, :between)
            when "boolean" then pick_matching(:equal_to)
            else STATEMENTS
          end
        end

        def pick_matching(*matching)
          STATEMENTS.select { |statement| matching.include? statement[:type] }
        end
      end
    end
  end
end
