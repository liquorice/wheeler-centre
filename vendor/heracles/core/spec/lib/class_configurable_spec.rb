require "spec_helper"

describe Heracles::ClassConfigurable do
  class ConfigurableModel
    include Heracles::ClassConfigurable
  end

  it "provides a default config class method" do
    expect(ConfigurableModel.config).to eq({})
  end

  it "provides a default config instance method" do
    expect(ConfigurableModel.new.config).to eq({})
  end

  it "delegates the instance config to the class method" do
    class ConfigurableModelWithConfig
      include Heracles::ClassConfigurable

      def self.config
        {foo: "bar"}
      end
    end

    expect(ConfigurableModelWithConfig.new.config).to eq({foo: "bar"})
  end
end
