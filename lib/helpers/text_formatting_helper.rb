module TextFormattingHelper
  def smartypants_format(text, options = {sanitize: true})
    if options[:sanitize] == true
      Redcarpet::Render::SmartyPants.render(
        sanitize(text, options[:sanitize_options] || {})
      )
    else
      Redcarpet::Render::SmartyPants.render(text)
    end
  end
  def widont_format(text)
    # Only make the final space non-breaking if the final
    # two words fit within 20 characters.
    if text.length > 20 && text[-20..-1][/\s+\S+\s+\S+$/].nil?
      text
    else
      text.gsub(/\s+(?=\S+$)/, "&nbsp;")
    end
  end

  def markdown(text)
    md = Redcarpet::Markdown.new(Redcarpet::Render::HTMLSmartyPants)
    md.render(text || '').html_safe
  end

  def markdown_line(text)
    renderer = Redcarpet::Render::HTMLWithoutBlockElements.new(filter_html: false)
    markdown = Redcarpet::Markdown.new(renderer, lax_spacing: true, no_intra_emphasis: true)

    markdown.render(text).html_safe
  end

  # encloses initial single or double quote, or their entities
  # (optionally preceeded by a block element and perhaps an inline element)
  # with a span that can be styled
  def initial_quotes(text)
    # $1 is the initial part of the string, $2 is the quote or entitity, and $3 is the double quote
    text.gsub(/((?:<(?:h[1-6]|p|li|dt|dd)[^>]*>|^)\s*(?:<(?:a|em|strong|span)[^>]*>)?)('|‘|&#8216;|("|“|&#8220;))/) {$1 + "<span class=\"#{'d' if $3}quo\">#{$2}</span>"}
  end
end
