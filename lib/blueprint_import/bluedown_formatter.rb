module LegacyBlueprint
  class BluedownFormatter
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
        logger.warn "Please install RDiscount (gem install rdiscount)."
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

      unless options[:markdown] == false
        begin
          text = MD_ENGINE.new(text, *MD_OPTIONS).to_html
        rescue => e
          raise "Markdown failed for: #{text.first(30)}: #{e.inspect}"
        end
      end

      text = replace_tokens(tokens, text)

      text = strip_spurious_paragraphs(text)

      text
    end

    def self.assetify(tokens, text, options={})
      puts ("Not implemented yet :(")
    end

    def self.replace_tokens(tokens, text)
      text.gsub(/<!--- (\w+) --->/) do |m|
        uid = $1
        tokens[uid] ? tokens[uid].strip : m
      end
    end

    def self.replace_apostrophes(text)
      text.gsub(/\xC3\xA2\xE2\x82\xAC\xE2\x84\xA2/, "'")
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
