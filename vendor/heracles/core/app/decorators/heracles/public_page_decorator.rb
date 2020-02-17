module Heracles
  class PublicPageDecorator < SimpleDelegator
    # Allow `==` comparisons between decorated and straight-up page objects
    delegate \
      :==,
      :instance_of?,
      :kind_of?,
      to: :__getobj__

    %i(ancestors path children siblings descendants subtree).each do |association|
      define_method(association) do
        decorate_relation(__getobj__.send(association).published.visible.in_order)
      end

      define_method("unscoped_#{association}") do
        __getobj__.send(association)
      end
    end

    def root
      @root ||= begin
        root_page = if unscoped_root.published? && unscoped_root.visible?
          unscoped_root
        else
          __getobj__.path.to_a.detect { |page| page.published? && page.visible? }
        end

        decorate(root_page)
      end
    end

    def unscoped_root
      __getobj__.root
    end

    def parent
      @parent ||= begin
        parent_page = if unscoped_parent && unscoped_parent.published? && unscoped_parent.visible?
          unscoped_parent
        else
          __getobj__.path.to_a.reverse.detect { |page| page.published? && page.visible? }
        end

        decorate(parent_page)
      end
    end

    def unscoped_parent
      __getobj__.parent
    end

    # Fetching collection from parent page
    def child_collection_with_slug(*)
      decorate(super)
    end

    # Collection child pages
    def pages
      decorate_relation(super).published.visible
    end

    private

    def decorate(object)
      self.class.new(object) if object
    end

    def decorate_relation(relation)
      PublicPageRelation.new(relation)
    end

    class PublicPageRelation < SimpleDelegator
      def to_a
        decorate(super)
      end

      def find(*)
        decorate(super)
      end

      def find_by(*)
        decorate(super)
      end

      def find_by!(*)
        decorate(super)
      end

      def take(*)
        decorate(super)
      end

      def first
        decorate(super)
      end

      def last
        decorate(super)
      end

      def second
        decorate(super)
      end

      def third
        decorate(super)
      end

      def fourth
        decorate(super)
      end

      def fifth
        decorate(super)
      end

      def forty_two
        decorate(super)
      end

      private

      def decorate(result)
        result.respond_to?(:each) ? decorate_array(result) : decorate_record(result)
      end

      def decorate_record(record)
        PublicPageDecorator.new(record)
      end

      def decorate_array(array)
        array.map { |record| decorate_record(record) }
      end
    end
  end
end
