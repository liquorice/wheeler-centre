class DoubleEncodeAllCodeInsertables < ActiveRecord::Migration
  def up
    ActiveSupport.escape_html_entities_in_json = false

    puts "Double-escaping all code insertable values (to match new insertable editor behaviour)"

    # This migration takes an original code insertable like this:
    #
    #   <div contenteditable="false" insertable="code" value='{"code":"&lt;p class=\"test\"&gt;Hi.&lt;/p&gt;"}'></div>
    #
    # And converts it to:
    #
    #   <div contenteditable="false" insertable="code" value="{&quot;code&quot;:&quot;&amp;lt;p class=&amp;quot;test&amp;quot;&amp;gt;Hi.&amp;lt;/p&amp;gt;&quot;}"></div>
    #

    Heracles::Page.find_each do |page|
      page.fields.to_a.each do |field|
        if field.field_type == "content"
          html_doc = Nokogiri::HTML::fragment(field.value)
          html_doc.css("[insertable='code'][value]").each do |insertable_node|
            value_str = insertable_node["value"]
            value_data = JSON.parse(value_str)
            value_data.each { |k,v| value_data[k] = CGI.escape_html(v) }
            value_str = value_data.to_json

            escaped_value_str = CGI.escape_html(value_str)

            insertable_node.remove_attribute "value"

            insertable_node_str = insertable_node.to_s
            insertable_node_str.sub!(%r{(></div>)$}, "")
            insertable_node_str = insertable_node_str + " value=\"#{escaped_value_str}\"></div>"

            cdata = html_doc.document.create_cdata(insertable_node_str)
            insertable_node.replace(cdata)
          end

          page.fields_data[field.field_name]["value"] = html_doc.to_s
          page.fields_data_will_change!
        end
      end

      page.save!
    end
  end

  def down
    ActiveSupport.escape_html_entities_in_json = false

    puts "Reverting all code insertable values to singly-escaped format"

    # This migration should do the opposite of the above (see examples above)

    Heracles::Page.find_each do |page|
      page.fields.to_a.each do |field|
        if field.field_type == "content"
          html_doc = Nokogiri::HTML::fragment(field.value)
          html_doc.css("[insertable='code'][value]").each do |insertable_node|
            value_str = insertable_node["value"]
            puts value_str

            value_data = JSON.parse(value_str)
            value_data.each { |k,v| value_data[k] = CGI.unescape_html(v) }
            value_str = value_data.to_json

            insertable_node["value"] = value_str
          end

          page.fields_data[field.field_name]["value"] = html_doc.to_s
          page.fields_data_will_change!
        end
      end

      page.save!
    end
  end
end
