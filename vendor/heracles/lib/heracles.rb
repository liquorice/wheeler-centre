require "heracles/engines"
Heracles::ENGINE_NAMES.each do |engine|
  lib = File.expand_path("../../#{engine}/lib", __FILE__)
  $:.push lib unless $:.include?(lib)
end

require "heracles-core"
