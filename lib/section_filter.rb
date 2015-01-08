require "heracles/content_field/filter"

module Heracles
  module Sites
    module WheelerCentre
      class SectionFilter < Heracles::ContentField::Filter
        def call
          html_doc.css('.figure__display--full-width').wrap("<section class='section--full'></section>")

          new_doc = Nokogiri::HTML::fragment(''); section = nil
          html_doc.xpath('*').each do |node|

            if node.name == 'section'
              new_doc.add_child(section) unless section.nil?
              new_doc.add_child(node)
              section = nil
              next
            end

            section ||= new_doc.document.create_element 'section', class: 'section--normal'
            section.add_child node
          end

          new_doc.add_child(section) unless section.nil?
          new_doc
        end
      end
    end
  end
end
