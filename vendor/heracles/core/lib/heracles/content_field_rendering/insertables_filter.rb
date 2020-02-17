module Heracles
  module ContentFieldRendering
    class InsertablesFilter < Filter
      def call
        html_doc.css("[insertable][value]").each do |insertable_node|
          insertable_type   = insertable_node["insertable"]
          insertable_data   = JSON.parse(insertable_node["value"])
          renderer_options  = (options[insertable_type.to_sym].presence || {}).merge(site: site)
          renderer_class    = find_insertable_renderer_class(insertable_type, (options[insertable_type.to_sym] || {})[:renderer_name])
          renderer          = renderer_class.new(insertable_data, renderer_options)

          unless renderer_options[:disabled]
            output = if renderer.respond_to?(:cache_key) && controller.perform_caching
              fragment_for_insertable_renderer(renderer)
            else
              renderer.render
            end

            insertable_node.replace output
          else
            insertable_node.replace ""
          end
        end

        html_doc
      end

      private

      def find_insertable_renderer_class(insertable_type, custom_renderer_class_name)
        custom_class  = custom_renderer_class_name.camelize.constantize rescue nil

        class_name    = (custom_renderer_class_name.presence || insertable_type).to_s.camelize + "InsertableRenderer"
        site_class    = "#{site.module}::#{class_name}".constantize rescue nil
        public_class  = "Heracles::#{class_name}".constantize rescue nil

        custom_class || site_class || public_class || Heracles::NullInsertableRenderer
      end

      def fragment_for_insertable_renderer(renderer)
        read_fragment_for_insertable_renderer(renderer) || write_fragment_for_insertable_renderer(renderer)
      end

      def read_fragment_for_insertable_renderer(renderer)
        controller.read_fragment(renderer.cache_key)
      end

      def write_fragment_for_insertable_renderer(renderer)
        controller.write_fragment(renderer.cache_key, renderer.render)
      end
    end
  end
end
