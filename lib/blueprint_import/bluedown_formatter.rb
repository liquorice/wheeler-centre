module LegacyBlueprint
  class BluedownFormatter
    require "nokogiri"

    include Singleton
    include ActionView::Helpers::SanitizeHelper
    extend ActionView::Helpers::SanitizeHelper::ClassMethods
    extend ActionView::Helpers::TextHelper
    extend ActionView::Helpers::TagHelper
    extend ActionView::Helpers::AssetTagHelper


    def self.initialise_formatting_engine
      md_engine = nil

      # RDiscount is preferred
      if defined?(RDiscount)
        md_engine = RDiscount
        md_options = [:smart]
        logger.info "Markdown library: RDiscount."
      elsif defined?(PEGMarkdown)
        md_engine = PEGMarkdown
        md_options = []
        logger.info "Markdown library: PEGMarkdown."
      else
        # BlueCloth is slooow. But we know it's installed, because engine.rb
        # demands it if rdiscount/peg_markdown aren't present.
        md_engine = BlueCloth
        md_options = []
        logger.info "Markdown library: BlueCloth."
        logger.warn "BlueCloth functions fine, but is quite slow. " +
          "Consider installing RDiscount instead (gem install rdiscount)."
      end

      const_set "MD_ENGINE", md_engine
      const_set "MD_OPTIONS", md_options
    end


    def self.mark_up(text, options = {})
      initialise_formatting_engine unless defined?(MD_ENGINE)

      return '' if text.blank?

      tokens = {}

      text = sanitize(text) if options[:sanitize] == true

      unless options[:assetify] == false
        text = assetify(tokens, text, options[:subject])
      end


      # We can't convert this syntax, and I don't think it's used anywhere anyway
      # unless options[:quick_links] == false
      #   text = quick_linkify(tokens, text, options)
      # end

      unless options[:markdown] == false
        begin
          text = MD_ENGINE.new(text, *MD_OPTIONS).to_html
        rescue => e
          raise "Markdown failed for: #{text.first(30)}: #{e.inspect}"
        end
      end

      # Convert any iframes into insertable-approriate versions
      unless options[:iframify] == false
        text = iframify(text)
      end

      # Convert any <object> into code insertables versions
      unless options[:objectify] == false
        text = objectify(text)
      end

      text = tidy(text) if options[:sanitize] == true

      text = replace_tokens(tokens, text)

      text = strip_spurious_paragraphs(text)

      text
    end


    # Syntax: [slug->text]

    # NOTE: luckily, this doesn't seem to be used, so I can ignore.
    def self.quick_linkify(tokens, text, options)
      text.gsub(/(^|[^\\])\[(.*?)->(.*?)\]/) do |match|
        sbound = $1
        page_slug = $2
        link_text = $3

        out = ""
        if p = Page.for_slug(page_slug, :search_pathprints => true)
          link_text = p.title if link_text.blank?
          out << %Q`<a href="#{p.url}">#{link_text}</a>`
        else
          out << "{missing page}"
        end

        tokenize_snippet(tokens, out, sbound)
      end
    end


    # Syntax: [[name|option_key=option_val,keyN=valN]](optional caption)
    #   or [[name(thumbnail_type):class]]
    #   or [[name(thumbnail_type)]]
    #   or [[name:class]]
    #   or [[name]]
    def self.assetify(tokens, text, object_scope)
      text.gsub(/(^|[^\\])\[\[(\w.*?)\]\](\(.*?[^\\]\))?/m) do |m|
        sbound = $1
        astr = $2
        cap = $3.strip if $3

        asset_name, options = parse_asset_string(astr)
        puts options.inspect

        if cap
          cap.gsub!("\\)", ")")
          cap.gsub!(/^\((.*)\)$/m, '\1')
          options[:caption] = cap
        end

        # find the asset
        # ORIG
        # asset = nil
        # if object_scope.respond_to?(:assets)
        #   asset = object_scope.assets.named(asset_name)
        # end
        # asset ||= Page.site.gather(Asset).find_by_name(asset_name)

        # Find the asset, assuming we've already imported all the Blueprint assets
        if object_scope
          # Find an asset connected directly to the object
          object_class_name = object_scope.class.name.sub(/LegacyBlueprint::/, "")
          if /^Tum/.match object_class_name
            object_class_name = "TumPost"
          elsif object_class_name == "CenevtEvent"
            object_class_name = "EvtEvent"
          elsif object_class_name == "CenplaPage"
            object_class_name = "Page"
          end
          asset = Heracles::Asset.where(
            blueprint_attachable_type: object_class_name,
            blueprint_attachable_id: object_scope["id"].to_i,
            blueprint_name: asset_name
          ).first
          unless asset
            asset = Heracles::Asset.where(
              blueprint_attachable_type: object_class_name,
              blueprint_attachable_id: object_scope["id"].to_i,
              file_basename: asset_name
            ).first
          end
        else
          asset = Heracles::Asset.where(blueprint_name: asset_name).first
        end

        # replace asset reference with HTML
        out = present_asset(asset, object_scope, options)
        tokenize_snippet(tokens, out, sbound)
      end
    end

    def self.iframify(text)
      embedly_api = Embedly::API.new :key => ENV["EMBEDLY_API_KEY"], :user_agent => 'Mozilla/5.0 (compatible; wheelercentre/1.0; hello@icelab.com.au)'
      fragment = Nokogiri::HTML(text)
      iframes = fragment.xpath("//iframe")

      iframes.each do |iframe|
        url = iframe['src']
        url = url.gsub(/youtube-nocookie/, "youtube")
        puts "Adding video insertable for #{url}"

        begin
          obj = embedly_api.extract :url => url
        rescue Embedly::BadResponseException
          puts "retrying embedly api request..."
          retry
        end

        dump = obj[0].marshal_dump
        embedData = {}

        if dump[:media].present? && dump[:media][:html].present?
          # The data return by the embedly ruby library is slightly different to that of the
          # javascript one, so we do some mangling
          embedData[:provider_url]     = dump[:provider_url]
          embedData[:provider_name]    = dump[:provider_name]
          embedData[:description]      = dump[:description]
          embedData[:title]            = dump[:title]
          embedData[:url]              = dump[:url]
          embedData[:height]           = dump[:media][:height]
          embedData[:width]            = dump[:media][:width]
          embedData[:html]             = dump[:media][:html]
          embedData[:type]             = dump[:media][:type]
          embedData[:thumbnail_url]    = dump[:images][0]['url'] if dump[:images].any?
          embedData[:thumbnail_height] = dump[:images][0]['height'] if dump[:images].any?
          embedData[:thumbnail_width]  = dump[:images][0]['width'] if dump[:images].any?

          video_insertable = content_tag(:div, '', value: {url: url, display: '', embedData: embedData}.to_json, insertable: 'video', contenteditable: 'false')
          iframe.replace video_insertable
        else
          code_insertable = content_tag(:div, '', value: {code: CGI.escape_html(iframe.to_s)}.to_json, insertable: 'code', contenteditable: 'false')
          iframe.replace code_insertable
        end
      end
      fragment.to_html
    end

    def self.objectify(text)
      fragment = Nokogiri::HTML(text)
      objects = fragment.xpath("//object")

      objects.each do |object|
        code_insertable = content_tag(:div, '', value: {code: CGI.escape_html(object.to_s)}.to_json, insertable: 'code', contenteditable: 'false')
        object.replace code_insertable
      end
      fragment.to_html
    end

    # Options:
    #  EITHER
    #   path_only - just display the filepath
    #   link_text - like path_only but creates a link with the given text
    #
    #  IMAGES
    #   size - the thumbnail to display
    #   class - the CSS class
    #   link - is the image a link?
    #   enlarge - the thumbnail to enlarge to
    #   title - the title and alt-text of the image
    #
    #  DOWNLOADS
    #   show_name - if "false", don't show asset name
    #   show_size - if "false", don't show asset filesize
    def self.parse_asset_string(astr)
      options = {}
      asset_name, options_string = astr.split('|')

      unless options_string.blank?
        strs = options_string.gsub(/([^\\]),/,'\1|').gsub(/\\,/,',').split('|')
        strs.each do |opt_pair|
          key, val = opt_pair.strip.split("=", 2)
          options[key.to_sym] = val unless key.blank? || val.blank?
        end
      end

      # Old syntax for specifying class and thumbnail:
      if options.empty?
        asset_name, asset_class_name = asset_name.split(':')
        if asset_name.gsub!(/\((\w+)\)/, '')
          asset_thumb = $1
        else
          asset_thumb = nil
        end
        options[:class] = asset_class_name unless asset_class_name.blank?
        options[:size] = asset_thumb unless asset_thumb.blank?
      end

      # Some options are true if they are not defined:
      [:show_icon, :show_size, :show_name].each do |key|
        options[key] = true if !options[key] || options[key] == "true"
      end

      # Set the title option to the asset name if unspecified.
      options[:title] ||= asset_name

      [asset_name, options]
    end


    def self.present_asset(asset, object_scope, options = {})
      # TODO: perhaps output a warning?
      return '[missing asset]' unless asset

      # TODO: this should return the <div> with data attributes for the Heracles asset

      # TODO: need different things based on whether it's an image or not (e.g. a PDF, etc.).
      # Images should be insertables
      # Non-image assets should be inline links with some default content.

      display = "Right-aligned"
      if options[:size] == "Size8"
        display = ""
      end

      insertable_value = {
        asset_id: asset.id,
        display: display,
        alt_text: options[:caption],
        caption: options[:caption]
      }
      if options[:link].present?
        insertable_value[:link] = {
          href: options[:link]
        }
      end

      asset_insertable = <<HTML
      <div contenteditable="false" insertable="image" value='#{ERB::Util.h(insertable_value.to_json)}'></div>
HTML

      return asset_insertable

      # ORIG:
      # We don't need any of this, since the insertable div is everything we need

      # snippet = asset_snippet(asset.asset_type)

      # page = Page.primordial
      # if object_scope.kind_of?(Page)
      #   page = object_scope
      # elsif object_scope.respond_to?(:page) && object_scope.page
      #   page = object_scope.page
      # end

      # ingredient = Page.site.invoke_rule(
      #   page,
      #   :ingredient_for_asset_insertion,
      #   asset.asset_type
      # )
      # if ingredient
      #   resource = Page.site.template_at("ingredients/#{ingredient}.html.erb")
      #   tmpl = ERB.new(resource.markup)
      # else
      #   tmpl = snippet
      # end

      # return tmpl.result(binding)
    end

    def self.asset_snippet(asset_type)
      @@asset_snippets ||= {}
      if !@@asset_snippets[asset_type]
        tmpl_path = File.join(RAILS_ROOT, 'core', 'text_formatting', 'views')
        path = File.join(tmpl_path, "#{asset_type}.erb")
        data = IO.read(path)
        tmpl = ERB.new(data)
        @@asset_snippets[asset_type] = tmpl
      end
      @@asset_snippets[asset_type]
    end


    def self.tokenize_snippet(tokens, snip, sbound = '', ebound = '')
      # uid = String.random(12)
      uid = SecureRandom.hex(12)
      tokens[uid] = snip
      "#{sbound}<!--- #{uid} --->#{ebound}"
    end


    def self.replace_tokens(tokens, text)
      text.gsub(/<!--- (\w+) --->/) do |m|
        uid = $1
        tokens[uid] ? tokens[uid].strip : m
      end
    end

    def self.strip_spurious_paragraphs(text)
      html_doc = Nokogiri::HTML::fragment(text)

      # Remove empty paragraph tags
      html_doc.css("p").each do |p_element|
        if p_element.inner_html.blank? && p_element.children.blank?
          p_element.replace ""
        end
      end

      # While we're at it, remove some spurious newlines
      html_doc.to_s.gsub(/\n{2,}/, "\n\n")
    end


    def self.set_controller(cntlr)
      @controller = cntlr
    end


    def self.sanitize(text)
      self.instance.sanitize(text)
    end


    def self.logger
      Rails.logger
    end

  end
end
