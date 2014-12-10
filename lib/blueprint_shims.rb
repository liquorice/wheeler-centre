require "ostruct"

module LegacyBlueprint
  class Base < SimpleDelegator
    def initialize(*)
      __setobj__({})
    end

    def init_with(coder)
      __setobj__(coder['attributes'])
    end

    def yaml_initialize(tag, val)
      __setobj__(val["attributes"])
    end
  end

  %i(
    CenevtEvent
    Site
    User
  ).each do |legacy_class|
    eval "class #{legacy_class} < Base; end"
  end
end
