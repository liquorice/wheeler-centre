module Heracles
  class CreatePage
    include Interactor

    def call
      context.page = build_page
      prevent_page_slugs_collision

      if context.page.save
        create_default_children if create_default_children?
      else
        context.fail!
      end
    end

    private

    def build_page
      Heracles::Page.new_for_site_and_page_type(context.site, context.page_type).tap do |page|
        page.attributes = context.page_params
      end
    end

    def prevent_page_slugs_collision
      context.page.slug = "#{context.page.slug}-1" if context.page.invalid? && context.page.errors.messages.keys.include?(:url)
    end

    def create_default_children?
      !!context.create_default_children
    end

    def create_default_children
      # Reload to get the right child_ancestry value for the newly created page
      context.page.reload

      context.default_children = context.page.default_children_config.map do |child_config|
        context.page.class.new_for_site_and_page_type(context.page.site, child_config[:type]).tap do |child_page|
          child_page.parent = context.page
          child_page.page_order_position = :last

          apply_child_config_to_page(child_config, child_page)

          child_page.save validate: false
        end
      end
    end

    def apply_child_config_to_page(child_config, page)
      # Basic attributes
      page.title      = child_config[:title]
      page.slug       = child_config[:slug]
      page.published  = !!child_config[:published]
      page.hidden     = !!child_config[:hidden]
      page.locked     = !!child_config[:locked]

      # Fields
      child_config.fetch(:fields) { {} }.
        select { |field_name, _| page.fields.has_config?(field_name) }.
        each do |field_name, field_attrs|
          page.fields[field_name].assign field_attrs
          field_attrs.each do |attr_name, attr_value|
            page.fields[field_name].send(:"#{attr_name}=", attr_value)
          end
        end
    end
  end
end
