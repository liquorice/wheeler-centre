module Heracles
  module Admin
    module ApplicationHelper
      include Heracles::CloudinaryAssetHelper
      include Heracles::TransloaditAssetHelper

      def site_page_preview_url(site, page)
        "http://#{Heracles.configuration.admin_host}/#{page.url}/__preview"
      end

      def admin_body_classes
        [
          "admin",
          controller_name.parameterize,
          action_name.parameterize
        ]
      end

      def open_tree_nav(test)
        test ? "tree-nav--open" : ""
      end

      def highlight_current_leaf(test)
        test ? "tree-nav__current-page" : ""
      end

      def get_parent_tree(page)
        pages = []
        page.ancestors.each do |parent|
          pages << parent.siblings.collect(&:title)
        end
        pages
      end

      def pages_in_path(page)
        if page.try(:new_record?)
          page = page.try(:parent) || site.pages.find_by(title: 'Home')
        end

        return [] unless page.try(:site)

        pages = page.site.pages.
          uncontained.
          where("
            (ancestry IS NULL) OR
            ((ancestry = ? OR ancestry LIKE ?) AND ancestry_depth <= ?) OR
            (ancestry LIKE ? AND ancestry_depth <= ?) OR
            (ancestry LIKE ? AND ancestry_depth <= ?)",
            page.root_id, "#{page.root_id}/%", page.depth - 1,
            "%#{page.parent_id}", page.depth,
            "%#{page.id}", page.depth + 1
          ).
          ordered_by_ancestry_and("page_order").
          preload(:site)

        page.class.arrange_nodes(pages.to_a)
      end

      def build_page_tree(tree, page_policy_source, page_type_policy_scope_source, current_page=nil, parent=nil)
        return if tree.blank?
        tree = content_tag :ol, class: "tree-nav__children" do
          tree.each do |page, children|
            next unless page.id
            item_class = "tree-nav__list-item #{highlight_current_leaf(page == current_page)}"
            item_class += " tree-nav__list-item--home" if page.slug == "home"
            tree_item = content_tag :li, class: item_class, data: { update_url: api_site_page_path(site, page) } do
              wrapper = content_tag :div, class: "tree-nav__list-item-wrapper" do
                link_url = page.collection? ?
                  site_collection_pages_path(collection_id: page, open_tree_nav: true) :
                  edit_site_page_path(id: page, open_tree_nav: true)
                icon_type = if page.collection?
                  "fa-folder-open"
                elsif page.hidden?
                  "fa-eye-slash"
                else
                  "fa-file"
                end
                link_class = page.collection? ?
                  "tree-nav__list-item-collection" :
                  "tree-nav__list-item-title"
                link = content_tag :a, class: link_class, href: link_url do
                  concat content_tag :i, "", class: "fa #{icon_type}"
                  concat page.title
                  if children.present?
                    child_count = content_tag :span, class: "tree-nav__child-count" do
                      concat content_tag :i, "", class: "fa fa-angle-right"
                      concat children.length
                    end
                    concat child_count
                  end
                end

                menu = content_tag :div, class: "tree-nav__list-item-menu" do
                  delete_link = content_tag :a, href: site_page_path(site, page), data: { method: "delete", confirm: "Are you sure you want to delete this page? All child pages will also be deleted. THERE IS NO UNDO." }, class: "tree-nav__list-delete" do
                    concat content_tag :i, "", class: "fa fa-trash-o"
                  end
                  move_link = content_tag :a, href: "#", class: "tree-nav__list-move" do
                    concat content_tag :i, "", class: "fa fa-arrows"
                  end
                  add_child = content_tag :span, class: "tree-nav__list-add tree-nav__list-item", data: { "view-page-type-selector" => true } do
                    concat content_tag :i, "", class: "fa fa-plus-circle"
                    page_type_policy_scope_source.call(page.allowed_child_page_classes).each do |page_class|
                      # TODO: Do something different to visually distinguish pages and collections
                      class_name = "tree-nav__new-page tree-nav__new-page--"
                      class_name += if page_class.collection?
                        "collection"
                      elsif page_class.hidden?
                        "hidden"
                      else
                        "page"
                      end
                      concat link_to page_class.page_type.humanize, new_site_page_path(parent_id: page, page_type: page_class.page_type), class: class_name
                    end
                  end

                  concat delete_link if page_policy_source.call(page).destroy?
                  concat add_child if page.child_pages_allowed?
                  concat move_link if page.sortable?
                end

                concat link
                concat menu
              end
              concat wrapper
              concat build_page_tree(children, page_policy_source, page_type_policy_scope_source, current_page, page)
            end
            concat tree_item
          end
        end
        tree
      end

      def build_breadcrumbs(page)
        ancestors = []
        page.ancestors.each do |ancestor|
          ancestors << link_to(ancestor.slug, edit_site_page_path(site, ancestor))
        end
        output = "/"
        if ancestors.length > 0
          output += "#{ancestors.join("/")}/"
        end
        output
      end

      # Return the site-specific JS alongside the shared admin.js for HeraclesAdmin
      def site_javascripts(site)
        files = []
        files << asset_path("heracles/admin/admin.js").to_json
        files << asset_path("#{site.engine_path}/admin.js").to_json if site
        files.join ","
      end

      def site_content_editor_css(site)
        files = []
        files << stylesheet_path("tinymce/themes/basic/admin_content_editor").to_json
        files << stylesheet_path("#{site.engine_path}/admin_content_editor").to_json if site
        files.join ","
      end

      def site_page_actions_template_exists?(site)
        lookup_context.template_exists?("#{site.engine_path}/admin/_page_actions")
      end

      # Return the public URL of a page (based on the canonical/first hostname)
      def public_url(site, page)
        "http://#{site.primary_hostname}#{page.absolute_url}"
      end

      # Return the tags delimited by the expected delimiter
      # ActAsTaggableOn returns `tag_list` comma separated all the time
      def demlimited_tag_list(tags)
        tags.map {|t| t.name }.join(ActsAsTaggableOn.delimiter)
      end

      # Renders `additional_template_context_for` partial from `views/heracles/sites/#{site}/admin` directory
      # Partial could have multiple `append` directives to extend areas defineds below helper
      def additional_template_context_for(site)
        return unless site

        template = "admin/additional_template_context_for"
        engine_path = site.engine_path
        render "#{engine_path}/#{template}" if lookup_context.exists?(template, [engine_path], true)
      end
    end
  end
end
