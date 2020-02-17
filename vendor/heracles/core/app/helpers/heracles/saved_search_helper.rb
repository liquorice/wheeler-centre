require "digest/sha1"
require "render_anywhere"

module Heracles
  module SavedSearchHelper
    class SiteNotFound < StandardError; end

    MINUTES_TO_CACHE = 5

    def saved_search_results(search_options)
      search_options[:site] ||= try(:site)
      raise SiteNotFound unless search_options[:site]

      if controller.perform_caching
        fragment_for_saved_search_results(search_options)
      else
        render_saved_search_results(search_options)
      end
    end

    private

    def fragment_for_saved_search_results(search_options)
      read_fragment_for_saved_search_results(search_options) || write_fragment_for_saved_search_results(search_options)
    end

    def read_fragment_for_saved_search_results(search_options)
      controller.read_fragment(cache_key_for_saved_search(search_options))
    end

    def write_fragment_for_saved_search_results(search_options)
      controller.write_fragment(cache_key_for_saved_search(search_options), render_saved_search_results(search_options)).html_safe
    end

    def cache_key_for_saved_search(search_options)
      [
        "saved_search",
        Digest::SHA1.hexdigest(search_options.to_s),
        Time.current.change(min: Time.current.min - (Time.current.min % MINUTES_TO_CACHE)).to_s(:nsec) # the beginning of the time period
      ].join("/")
    end

    def render_saved_search_results(search_options)
      site          = search_options.fetch(:site)
      query_builder = SearchQueryBuilder.new(search_options, site)
      results       = Search.new(query_builder.queries, search_options[:combination_type], site).results

      Renderer.new(
        results: results,
        site:    site,
        theme:   search_options[:theme],
        data:    data # FIXME: this depends on this module being included inside SavedSearchInsertableRenderer
      ).render
    end

    class SearchQueryBuilder
      attr_reader :conditions, :site

      def initialize(options, site)
        @conditions = options.fetch(:conditions)
        @site       = site

        raise ArgumentError, "at least one search condition is needed" if conditions.blank?
      end

      def queries
        conditions.map { |condition| condition_to_query(condition) }.compact
      end

      private

      def condition_to_query(condition)
        case condition[:condition_type].to_sym
          when :page  then {action: :compare,  request: "type = '#{site.module}::#{condition[:match_value].camelize}'"}
          when :tag   then {action: :fulltext, request: "search_by_tags(#{condition[:match_value].split(",").map(&:strip)})"}
          when :field then {action: :compare,  request: select_match_type(condition)}
        end
      end

      def select_match_type(condition)
        field, match_type, match_value = condition[:field], condition[:match_type], condition[:match_value]

        if %w(between any_of all_of).include?(match_type)
          match_value = match_value.split(",").map(&:strip)
        end

        if Heracles::Page.column_names.include?(field.to_s)
          # Column based field
          "#{field} #{select_operator(match_type)} '#{match_value}'"
        else
          # Heracles based field
          "fields_data#>>'{#{field}, value}' #{select_operator(match_type)} '#{match_value}'"
        end
      end

      def select_operator(match_type)
        operators = {
          equal_to:     "=",
          less_than:    "<",
          greater_than: ">",
          between:      "BETWEEN",
          any_of:       "ANY",
          all_of:       "ALL",
          less_than_or_equal_to:    "<=",
          greater_than_or_equal_to: ">="
        }
        operators.keys.include?(match_type.to_sym) ? operators[match_type.to_sym] : operators[:equal_to]
      end
    end

    class Search
      attr_reader :queries, :combination_type, :site

      def initialize(queries, combination_type, site)
        @queries          = queries
        @combination_type = combination_type
        @site             = site
      end

      def results
        (compare + fulltext).uniq
      end

      def compare
        Compare.new(published, combination_type, comparision_queries, fulltext_queries).results
      end

      def fulltext
        Fulltext.new(published, combination_type, fulltext_queries, comparision_queries).results
      end

      private

      def published
        Heracles::Page.where("published = ? AND site_id = ?", true, site.id)
      end

      def comparision_queries
        queries.select { |query| query[:action] == :compare }.map { |query| query[:request] }
      end

      def fulltext_queries
        queries.select { |query| query[:action] == :fulltext }.map { |query| query[:request] }
      end

      class Base
        attr_reader :pages, :combination, :queries, :extra

        def initialize(pages, combination, queries, extra)
          @pages       = pages
          @combination = combination
          @queries     = queries
          @extra       = extra
        end

        private

        def where_or_and
          combination == "any" ? or_query : and_query
        end
      end

      class Compare < Base
        def results
          queries.any? ? pages.instance_eval(query_string) : []
        end

        private

        def query_string
          where_or_and
        end

        def or_query
          "where(\"#{queries.join(" OR ")}\")"
        end

        def and_query
          "where(\"#{queries.join(" AND ")}\")#{fulltext_string}"
        end

        def fulltext_string
          ".#{extra.join(".")}" if extra.any?
        end
      end

      class Fulltext < Base
        def results
          (queries.any? && extra.empty?) || (extra.any? && combination == "any") ? where_or_and : []
        end

        private

        def or_query
          queries.inject([]) { |memo, request| memo + pages.instance_eval(request) }.compact
        end

        def and_query
          pages.instance_eval("#{queries.join(".")}")
        end
      end
    end

    class Renderer
      include RenderAnywhere

      def initialize(options={})
        @results     = options.fetch(:results)
        @site        = options.fetch(:site)
        @theme_name  = options.fetch(:theme)
        @data        = options.fetch(:data)
        @max_results = @data[:max_results].to_i if @data[:max_results].present?

        # TODO: the max results should be passed through to the search query.
        @results = @results.slice(0, @max_results) if @max_results.present?

        @theme_path = "saved_searches/#{@site.engine_path}/#{@theme_name}"
        @default_theme_path = "saved_searches/heracles/default"
      end

      # Keep RenderAnywhere's `#render` available for use apart from our
      # custom `#render` method.
      alias_method :render_in_controller, :render

      def render
        return "" if @results.blank?

        [
          render_template("opening", locals: {data: @data}),
          render_results,
          render_template("closing", locals: {data: @data}),
        ].join("").html_safe
      end

      def rendering_controller
        # Inject the site object into the standalone rendering controller, so
        # that it can provide the same environment as any other controller in
        # the actual site (i.e. it needs to provide a universally-available
        # `site` object).
        super.tap do |controller|
          controller.class_eval do
            attr_accessor :site
            helper_method :site
          end

          controller.site = @site
        end
      end

      private

      def render_template(template_name, options={})
        if does_template_exist("#{@theme_path}/_#{template_name}")
          render_in_controller partial: "#{@theme_path}/#{template_name}", locals: options.fetch(:locals, {})

        elsif does_template_exist("#{@default_theme_path}/_#{template_name}")
          render_in_controller partial: "#{@default_theme_path}/#{template_name}", locals: options.fetch(:locals, {})

        else
          ""
        end
      end

      # TODO: rename back to `template_exists?` once memoit releases a gem
      # update that includes their support for predicate methods.
      memoize \
      def does_template_exist(template)
        rendering_controller.template_exists?(template)
      end

      def render_results
        @results.each_with_index.inject("") { |memo, (result, index)|
          memo += render_result_template(result)
          memo += render_template("separator", locals: {data: @data}) if index < @results.size - 1
          memo
        }
      end

      def render_result_template(result)
        render_options = {locals: {page: result, data: @data}}

        render_template(result.page_type, render_options).presence || render_template("page", render_options)
      end
    end
  end
end
