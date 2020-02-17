require "spec_helper"
require "heracles/fielded/text_field"

describe Heracles::Fielded do
  class FieldedModel
    include ActiveModel::Model
    include ActiveModel::Dirty
    include ActiveModel::Validations
    include ActiveRecord::Callbacks

    include Heracles::Fielded

    attr_accessor :fields_data

    define_attribute_method :fields_data
  end

  class FieldedModelWithFieldsDefined < FieldedModel
    def fields_config
      [
        {name: "body", type: :text}
      ]
    end
  end

  describe "models" do
    context "new instances" do
      let(:model) { FieldedModel.new }

      it "has an empty fields proxy" do
        expect(model.fields).to be_a Heracles::Fielded::Fields
        expect(model.fields).to be_empty
      end

      it "can be assigned new fields" do
        model.fields["text"] = Heracles::Fielded::TextField.new(value: "hello")
        expect(model.fields).to_not be_empty
        expect(model.fields["text"]).to be_a Heracles::Fielded::TextField
        expect(model.fields["text"].value).to eq "hello"
        expect(model.fields_data["text"]).to eq({"field_type" => "text", "value" => "hello"})
      end
    end

    context "new instances with field config present" do
      let(:model) { FieldedModelWithFieldsDefined.new }

      it "has fields matching the config" do
        expect(model.fields).to_not be_empty
        expect(model.fields["body"]).to be_a Heracles::Fielded::TextField
        expect(model.fields_data["body"]["field_type"]).to eq "text"
      end
    end

    context "existing instances with fields" do
      let(:model) { FieldedModel.new(fields_data: {"text" => {"field_type" => "text", "value" => "blah"}}) }

      it "has a text field with value 'blah'" do
        expect(model.fields).to be_a Heracles::Fielded::Fields
        expect(model.fields).to_not be_empty
        expect(model.fields["text"]).to be_a Heracles::Fielded::Field
        expect(model.fields["text"]).to be_a Heracles::Fielded::TextField
        expect(model.fields["text"].value).to eq("blah")
      end

      it "stores an updated value in the model" do
        model.fields["text"].value = "foo"
        expect(model.fields_data).to eq({"text" => {"field_type" => "text", "value" => "foo"}})
      end
    end

    context "existing instances with both fields in both data and config" do
      let(:model) { FieldedModelWithFieldsDefined.new(fields_data: {"text" => {"field_type" => "text", "value" => "blah"}}) }

      it "has fields" do
        expect(model.fields).to be_a Heracles::Fielded::Fields
        expect(model.fields).to_not be_empty
      end

      it "has the fields from the data" do
        expect(model.fields["text"]).to be_a Heracles::Fielded::TextField
        expect(model.fields["text"].value).to eq "blah"
      end

      it "has the fields from the config" do
        expect(model.fields["body"]).to be_a Heracles::Fielded::TextField
        expect(model.fields_data["body"]["field_type"]).to eq "text"
      end

      it "has the fields from the config first" do
        expect(model.fields.to_a.map(&:field_name)).to eq ["body", "text"]
      end
    end
  end

  describe Heracles::Fielded::Fields do
    describe "dirty tracking" do
      specify "adding a new field marks the model dirty" do
        model = FieldedModelWithFieldsDefined.new
        expect(model).to receive(:fields_data_will_change!).at_least(:once)
        model.fields["body"].value = "foo"
      end

      specify "changing an existing field marks the model dirty" do
        model = FieldedModelWithFieldsDefined.new(fields_data: {"text" => {"field_type" => "text", "value" => "blah"}})
        expect(model).to receive(:fields_data_will_change!).at_least(:once)
        model.fields["text"].value = "foo"
      end

      specify "detaching a field marks the model dirty" do
        model = FieldedModel.new(fields_data: {"text" => {"field_type" => "text", "value" => "blah"}})
        expect(model).to receive(:fields_data_will_change!).at_least(:once)
        model.fields.delete("text")
      end
    end

    describe "validations" do
      it "validates all contained fields"
    end
  end

  describe Heracles::Fielded::Field do
    class TestField < Heracles::Fielded::Field
      data_attribute :x
      data_attribute :y

      validates :x, :y, presence: true, numericality: true

      def assign(attributes={})
        self.x = attributes[:x]
        self.y = attributes[:y]
      end
    end

    describe "attaching to a Fields" do
      it "can be attached to a Fields" do
        model = FieldedModel.new
        field = TestField.new
        field.field_name = "body"

        field.fields = model.fields
        expect(model.fields["body"]).to be_present
      end

      it "can be detached from a Fields" do
        model = FieldedModel.new
        field = TestField.new
        field.field_name = "body"

        field.fields = model.fields
        expect(model.fields["body"]).to be_present

        field.fields = nil
        expect(model.fields["body"]).to be_blank
      end
    end

    describe "dirty tracking" do
      specify "detaching marks the old model dirty" do
        model = FieldedModel.new(fields_data: {"body" => {"field_type" => "text", "value" => "blah"}})
        expect(model).to_not be_changed

        field = model.fields["body"]
        field.fields = nil

        expect(model).to be_changed
      end

      specify "attaching marks the new model dirty" do
        model = FieldedModel.new
        expect(model).to_not be_changed

        field = TestField.new
        field.field_name = "body"
        field.fields = model.fields
        expect(model).to be_changed
      end

      specify "changing values marks the model dirty" do
        model = FieldedModel.new(fields_data: {"body" => {"field_type" => "text", "value" => "blah"}})
        expect(model).to_not be_changed

        field = model.fields["body"]
        field.value = "foo"
        expect(model).to be_changed
      end

      specify "a value can be changed without a model" do
        field = TestField.new
        field.field_name = "body"
        expect { field.x = 1 }.to_not raise_error
      end
    end

    describe "validations" do
      it "has validations"
    end
  end
end
